#!/usr/bin/env bash
# automatically rename the labels to avoid the conflicts across papers.

for dir in sdfuzz ; do
    sed -i '' "s.\\\\label{.\\\\label{"$dir":.g" "$dir"/*tex
    #sed -i '' "s.\\\\ie{,}.\\\\ie{}.g" "$dir"/*tex
    #sed -i '' "s.\\\\ie{},.\\\\ie{}.g" "$dir"/*tex
    #sed -i '' "s.\\\\eg{,}.\\\\eg{}.g" "$dir"/*tex
    #sed -i '' "s.\\\\eg{},.\\\\eg{}.g" "$dir"/*tex
    #sed -i '' "s. \\\\cite{.~\\\\cite{.g" "$dir"/*tex
    #sed -i '' "s. \\\\citep{.~\\\\cite{.g" "$dir"/*tex
    sed -i '' "s.label={.label={"$dir":.g" "$dir"/*tex
    sed -i '' "s.\\\\autoref{.\\\\autoref{"$dir":.g" "$dir"/*tex
    sed -i '' "s.section{.subsection{.g" "$dir"/*tex
done
