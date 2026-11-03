# Chapter 1 Mermaid parse error

Past finding: none; no past bugfix entries were found.

Cue: the reader displayed a parse error immediately after the note about allocated thread memory.

Cause: the semicolon in `Note over T: blocked; stack and OS thread record remain allocated` separated Mermaid statements. The remaining text was parsed as diagram syntax. Replacing that semicolon with a comma changes the label without changing its meaning.

Falsifier: if the original diagram rendered with the local Mermaid CLI, the semicolon diagnosis would need further investigation. The original instead failed on line 7 with the same parser error shown by the reader.

Verification: Mermaid CLI 11.17.0 rendered 37 of 37 diagrams extracted from the course after the fix. The original failing input remains in the local Temp directory as `asyncproxy-sequence-before.mmd`. The course render input and resulting SVGs are also in Temp, under `asyncproxy-course-diagrams*`.

Tool substitution: the CLI's expected Chrome version was missing. The same CLI used the installed Google Chrome executable through an explicit Puppeteer configuration. Both the failing reproduction and the successful render used that configuration.

Scope: one punctuation character in a chapter 1 Mermaid note. No executable examples changed. The sequence-diagram sweep found this one semicolon-containing note.

Verification gap: the preceding editorial checks preserved code and inspected diagram labels, but did not render the changed diagrams. Render edited Mermaid diagrams before accepting future diagram changes.

User result: the diagram renders instead of displaying a syntax error. Disposition: fixed and render-verified.
