#!/bin/bash

echo 'Start convertions markdown files to Indesign or html'

echo '\t- book_cover_back (this makes sense)'
pandoc -s -f markdown -t icml -o converted/book_cover_back.icml book_cover_back.md

echo '\t- book_cover_back_inside (some legale stuff)'
pandoc -s -f markdown -t icml -o converted/book_cover_back_inside.icml book_cover_back_inside.md

echo '\t- book_cover_front (just testing)'
pandoc -s -f markdown -t icml -o converted/book_cover_front.icml book_cover_front.md

echo '\t- book_inhoud (test if this works better)'
pandoc -s -f markdown -t icml -o converted/book_inhoud.icml book_inhoud.md

echo '\t- book_test_markdown (help file for styling)'
pandoc -s -f markdown -t icml -o converted/book_test_markdown.icml book_test_markdown.md

echo 'Start convertions chapters'

echo '\t- bateson'
pandoc -s -f markdown -t icml -o converted/bateson.icml bateson.md
# pandoc -s -f markdown -t html -o converted/bateson.html bateson.md --metadata pagetitle="bateson"

echo '\t- comfortzone'
pandoc -s -f markdown -t icml -o converted/comfortzone.icml comfortzone.md

echo '\t- covey'
pandoc -s -f markdown -t icml -o converted/covey.icml covey.md

echo '\t- fast_cheap_great'
pandoc -s -f markdown -t icml -o converted/fast_cheap_great.icml fast_cheap_great.md

echo '\t- fixed_mindset'
pandoc -s -f markdown -t icml -o converted/fixed_mindset.icml fixed_mindset.md

echo '\t- flow'
pandoc -s -f markdown -t icml -o converted/flow.icml flow.md

echo '\t- golden_circle'
pandoc -s -f markdown -t icml -o converted/golden_circle.icml golden_circle.md

echo '\t- habits'
pandoc -s -f markdown -t icml -o converted/habits.icml habits.md
# pandoc -s -f markdown -t html -o converted/habits.html habits.md --metadata pagetitle="habits"

echo '\t- hammer'
pandoc -s -f markdown -t icml -o converted/hammer.icml hammer.md

echo '\t- ikigai'
pandoc -s -f markdown -t icml -o converted/ikigai.icml ikigai.md

echo '\t- kolb'
pandoc -s -f markdown -t icml -o converted/kolb.icml kolb.md

echo '\t- learning'
pandoc -s -f markdown -t icml -o converted/learning.icml learning.md

echo '\t- maslow'
pandoc -s -f markdown -t icml -o converted/maslow.icml maslow.md
# pandoc -s -f markdown -t docx -o converted/maslow.docx maslow.md
# pandoc -s -f markdown -t html -o converted/maslow.html maslow.md --metadata pagetitle="maslow"

echo '\t- mindset'
pandoc -s -f markdown -t icml -o converted/mindset.icml mindset.md

echo '\t- pareto'
pandoc -s -f markdown -t icml -o converted/pareto.icml pareto.md

echo '\t- programmer'
pandoc -s -f markdown -t icml -o converted/programmer.icml programmer.md
# pandoc -s -f markdown -t html -o converted/programmer.html programmer.md --metadata pagetitle="programmer"

echo '\t- smart'
pandoc -s -f markdown -t icml -o converted/smart.icml smart.md

echo '\t- ultimate'
pandoc -s -f markdown -t icml -o converted/ultimate.icml ultimate.md

echo 'done'