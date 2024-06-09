require 'jekyll'
require 'liquid'
require 'rexml/document'

module Jekyll
  class PseudocodeBlock < Liquid::Block
    @@number = 0

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      content = super
      @@number += 1
      content = process_pseudocode(content)
      "<div class='ps-root'>#{content}</div>"
    end

    def process_pseudocode(content)
      open_divs = []
      indent_level = 0
      content_lines = content.strip.split("\n")
      html_lines = []

      call_pattern = /\\CALL\{(.*?)\}\{(.*?)\}/

      replace_calls = lambda do |statement|
        statement.gsub(call_pattern) { |match| "<span class='ps-call'><span class='ps-funcname'>#{Regexp.last_match(1)}</span>(#{Regexp.last_match(2)})</span>" }
      end

      wrap_math_expressions = lambda do |statement|
        statement.gsub(/\$(.*?)\$/, '<span class="arithmatex">\\(\1\\)</span>')
      end

      process_control_statement = lambda do |keyword, condition|
        condition = wrap_math_expressions.call(condition)
        additional_keyword = keyword == "if" ? "then" : "do"
        if keyword == "for"
          condition = condition.gsub(/\\TO/, '<span class="ps-keyword">to</span>')
        end
        "<div class='ps-#{keyword.downcase} ps-indent-#{indent_level}'><span class='ps-keyword'>#{keyword.downcase}</span> (#{condition}) <span class='ps-keyword'>#{additional_keyword}</span>"
      end

      content_lines.each do |line|
        stripped_line = line.strip

        case stripped_line
        when /\\begin{algorithm}/
          html_lines << "<div class='ps-algorithm'>"
          open_divs << 'algorithm'
        when /\\end{algorithm}/
          if open_divs.last == 'algorithm'
            html_lines << "</div>"
            open_divs.pop
          end
        when /\\caption{(.*?)}/
          caption = stripped_line.match(/\\caption{(.*?)}/)[1]
          html_lines[-1] = "<div class='ps-algorithm with-caption'><div class='ps-caption'><span class='ps-keyword'>Algorithm #{@@number}</span> #{caption}</div>"
        when /\\begin{algorithmic}/
          html_lines << "<div class='ps-algorithmic'>"
          open_divs << 'algorithmic'
        when /\\end{algorithmic}/
          if open_divs.last == 'algorithmic'
            html_lines << "</div>"
            open_divs.pop
          end
        when /\\PROCEDURE{(.*?)}{(.*?)}/
          procedure_name = stripped_line.match(/\\PROCEDURE{(.*?)}{(.*?)}/)[1]
          params = stripped_line.match(/\\PROCEDURE{(.*?)}{(.*?)}/)[2]
          params = wrap_math_expressions.call(params)
          html_lines << "<div class='ps-procedure ps-indent-#{indent_level}'><span class='ps-keyword'>procedure </span><span class='ps-funcname'>#{procedure_name}</span>(#{params})"
          open_divs << 'procedure'
          indent_level += 1
        when /\\ENDPROCEDURE/
          if open_divs.last == 'procedure'
            indent_level -= 1
            html_lines << "<div class='ps-keyword'>end procedure</div></div>"
            open_divs.pop
          end
        when /\\IF{(.*?)}/
          condition = stripped_line.match(/\\IF{(.*?)}/)[1]
          statement = process_control_statement.call('if', condition)
          html_lines << statement
          open_divs << 'if'
          indent_level += 1
        when /\\ENDIF/
          if open_divs.last == 'if'
            indent_level -= 1
            html_lines << "<div class='ps-keyword'>end if</div></div>"
            open_divs.pop
          end
        when /\\FOR{(.*?)}/
          loop = stripped_line.match(/\\FOR{(.*?)}/)[1]
          statement = process_control_statement.call('for', loop)
          html_lines << statement
          open_divs << 'for'
          indent_level += 1
        when /\\ENDFOR/
          if open_divs.last == 'for'
            indent_level -= 1
            html_lines << "<div class='ps-keyword'>end for</div></div>"
            open_divs.pop
          end
        when /\\FOREACH{(.*?)}/
          loop = stripped_line.match(/\\FOREACH{(.*?)}/)[1]
          statement = "<div class='ps-foreach ps-indent-#{indent_level}'><span class='ps-keyword'>for each</span> (#{wrap_math_expressions.call(loop)}) <span class='ps-keyword'>do</span>"
          html_lines << statement
          open_divs << 'foreach'
          indent_level += 1
        when /\\ENDFOREACH/
          if open_divs.last == 'foreach'
            indent_level -= 1
            html_lines << "<div class='ps-keyword'>end for each</div></div>"
            open_divs.pop
          end
        when /\\WHILE{(.*?)}/
          condition = stripped_line.match(/\\WHILE{(.*?)}/)[1]
          statement = process_control_statement.call('while', condition)
          html_lines << statement
          open_divs << 'while'
          indent_level += 1
        when /\\ENDWHILE/
          if open_divs.last == 'while'
            indent_level -= 1
            html_lines << "<div class='ps-keyword'>end while</div></div>"
            open_divs.pop
          end
        when /\\REPEAT{(.*?)}/
          condition = stripped_line.match(/\\REPEAT{(.*?)}/)[1]
          statement = process_control_statement.call('repeat', condition)
          html_lines << statement
          open_divs << 'repeat'
          indent_level += 1
        when /\\ENDREPEAT/
          if open_divs.last == 'repeat'
            indent_level -= 1
            html_lines << "<div class='ps-keyword'>end repeat</div></div>"
            open_divs.pop
          end
        when /\\ELSEIF{(.*?)}/
          condition = stripped_line.match(/\\ELSEIF{(.*?)}/)[1]
          statement = process_control_statement.call('elseif', condition)
          html_lines << statement
          if open_divs.last == 'if'
            open_divs.pop
            open_divs << 'elseif'
          end
        when /\\ELSE/
          html_lines << "<div class='ps-else ps-indent-#{indent_level}'><span class='ps-keyword'>else</span>"
          if open_divs.last == 'if' || open_divs.last == 'elseif'
            open_divs.pop
            open_divs << 'else'
          end
        when /\\STATE{(.*?)}/
          statement = stripped_line.match(/\\STATE{(.*?)}/)[1]
          statement = replace_calls.call(statement)
          statement = wrap_math_expressions.call(statement)
          html_lines << "<div class='ps-state ps-indent-#{indent_level}'>#{statement}</div>"
        when /\\STATE\s+(.*)/
          statement = stripped_line.match(/\\STATE\s+(.*)/)[1]
          statement = replace_calls.call(statement)
          statement = wrap_math_expressions.call(statement)
          html_lines << "<div class='ps-state ps-indent-#{indent_level}'>#{statement}</div>"
        when /\\CALL{(.*?)}{(.*?)}/
          call = stripped_line.match(/\\CALL{(.*?)}{(.*?)}/)[1]
          params = stripped_line.match(/\\CALL{(.*?)}{(.*?)}/)[2]
          html_lines << "<div class='ps-call ps-indent-#{indent_level}'><span class='ps-funcname'>#{call}</span>(#{params})</div>"
        else
          html_lines << "<div class='ps-line ps-indent-#{indent_level}'>#{replace_calls.call(wrap_math_expressions.call(stripped_line))}</div>"
        end
      end

      open_divs.reverse_each { |div| html_lines << "</div>" }

      html_lines.join("\n")
    end
  end
end

Liquid::Template.register_tag('pseudocode', Jekyll::PseudocodeBlock)
