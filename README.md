# Jekyll Pseudocode Plugin

A Jekyll plugin to render pseudocode blocks using a simplified syntax similar to LaTeX.

## Installation

Add this line to your Jekyll site's `Gemfile`:

```ruby
gem "jekyll-pseudocode-latex"
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install jekyll-pseudocode-latex
```

## Usage

1. **Create a Pseudocode Block:**

   Use the `pseudocode` tag in your Markdown files to create a pseudocode block. Here is an example:

   ```markdown
   ---
   title: Quicksort Algorithm
   ---

   {% pseudocode %}
   % This quicksort algorithm is extracted from Chapter 7, Introduction to Algorithms (3rd edition)
   \begin{algorithm}
   \caption{Quicksort}
   \begin{algorithmic}
   \PROCEDURE{Quicksort}{$A, p, r$}
       \IF{$p < r$} 
           \STATE $q = $ \CALL{Partition}{$A, p, r$}
           \STATE \CALL{Quicksort}{$A, p, q - 1$}
           \STATE \CALL{Quicksort}{$A, q + 1, r$}
       \ENDIF
   \ENDPROCEDURE
   \PROCEDURE{Partition}{$A, p, r$}
       \STATE $x = A[r]$
       \STATE $i = p - 1$
       \FOR{$j = p$ \TO $r - 1$}
           \IF{$A[j] < x$}
               \STATE $i = i + 1$
               \STATE exchange $A[i]$ with $A[j]$
           \ENDIF
       \ENDFOR
       \STATE exchange $A[i]$ with $A[r]$
   \ENDPROCEDURE
   \end{algorithmic}
   \end{algorithm}
   {% endpseudocode %}
   ```

2. **Copy the CSS File:**

   Ensure you have the CSS file in `assets/css/pseudocode.css` with the following content. You can copy it from the plugin repository:

   ```css
   .ps-root {
     font-family: MJXZERO, MJXTEX;
     font-size: 1em;
     font-weight: 100;
     -webkit-font-smoothing: antialiased !important;
   }

   .ps-root .ps-algorithm {
     margin: .8em 0;
     border-top: 3px solid #000;
     border-bottom: 2px solid #000;
   }

   .ps-root .ps-algorithm.with-caption {
     border-bottom: 2px solid #000;
   }

   .ps-root .ps-indent-1 {
     margin-left: 1em;
   }

   .ps-root .ps-indent-2 {
     margin-left: 2em;
   }

   .ps-root .ps-indent-3 {
     margin-left: 3em;
   }

   .ps-root .ps-indent-4 {
     margin-left: 4em;
   }

   .ps-root .ps-indent-5 {
     margin-left: 5em;
   }

   .ps-root .ps-caption {
     display: block;
     border-bottom: 2px solid #000;
     margin-top: 4px !important;
     margin-bottom: 0.5em;
   }

   .ps-root .MathJax, .ps-root .MathJax_CHTML {
     text-indent: 0;
     font-size: 1em !important;
   }

   .ps-root .ps-line {
     margin: 0;
     padding: 0;
     line-height: 1.2;
   }

   .ps-root .ps-funcname {
     font-family: MJXZERO, MJXTEX;
     font-weight: 400;
     font-style: normal;
     text-transform: none;
   }

   .ps-root .ps-keyword {
     font-family: MJXZERO, MJXTEX;
     font-weight: 700;
     font-style: normal;
     text-transform: none;
   }

   .ps-root .ps-comment {
     font-family: MJXZERO, MJXTEX;
     font-weight: 400;
     font-style: normal;
     text-transform: none;
   }

   .ps-root .ps-linenum {
     font-size: .8em;
     line-height: 1em;
     width: 1.6em;
     text-align: right;
     display: inline-block;
     position: relative;
     padding-right: .3em;
   }

   .ps-root .ps-algorithmic.with-linenum .ps-line.ps-code {
     text-indent: -1.6em;
   }

   .ps-root .ps-algorithmic.with-linenum .ps-line.ps-code > span {
     text-indent: 0;
   }

   .ps-root .ps-algorithmic.with-scopelines .ps-block {
     border-left-style: solid;
     border-left-width: .1em;
     padding-left: .6em;
   }

   .ps-root .ps-algorithmic.with-scopelines > .ps-block {
     border-left: none;
   }
   ```

3. **Update `_config.yml`:**

   Add the following line to your `_config.yml` file to include the CSS file:

   ```yaml
   site-css:
     - "/assets/css/pseudocode.css"
   ```

4. **Include the CSS and MathJax in Your Pages or Layouts:**

   Add the following lines to the HTML of your pages or layouts to include the CSS and MathJax:

   ```html
   <link rel="stylesheet" href="assets/css/pseudocode.css">
   <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
   <script>
   window.MathJax = {
     tex: {
       inlineMath: [['$', '$'], ['\\(', '\\)']]
     },
     svg: {
       fontCache: 'global'
     }
   };

   (function () {
     var script = document.createElement('script');
     script.src = 'https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js';
     script.async = true;
     document.head.appendChild(script);
   })();
   </script>
   ```

5. **Build and Serve Your Site:**

   Rebuild and serve your Jekyll site to see the changes:

   ```bash
   bundle exec jekyll serve
   ```

By following these instructions, you'll be able to use the Jekyll pseudocode plugin in your site. If you encounter any issues, please refer to the plugin repository for additional troubleshooting and support.
```
