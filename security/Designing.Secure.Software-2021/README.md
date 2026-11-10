# Extraction index

The supplied filenames use `Title-Year-Chapter.pdf`, rather than the plan’s chapter-section suffix. Each PDF is treated as one chapter source. Section headings use the cleaned filename prefix. Source IDs below identify figure, table, and page references; PDF pages are numbered from 1 within each file.

| Source ID | Chapter | Source PDF | Pages | Markdown |
| --- | --- | --- | --- | --- |
| S2 | 2 | [Designing.Secure.Software-2021-2.pdf](Designing.Secure.Software-2021-2.pdf) | 20 | [Chapter 2](chapter-02.md) |
| S3 | 3 | [Designing.Secure.Software-2021-3.pdf](Designing.Secure.Software-2021-3.pdf) | 10 | [Chapter 3](chapter-03.md) |
| S4 | 4 | [Designing.Secure.Software-2021-4.pdf](Designing.Secure.Software-2021-4.pdf) | 22 | [Chapter 4 - Patterns](chapter-04.md) |
| S6 | 6 | [Designing.Secure.Software-2021-6.pdf](Designing.Secure.Software-2021-6.pdf) | 14 | [Chapter 6](chapter-06.md) |
| S7 | 7 | [Designing.Secure.Software-2021-7.pdf](Designing.Secure.Software-2021-7.pdf) | 17 | [Chapter 7](chapter-07.md) |
| S10 | 10 | [Designing.Secure.Software-2021-10.pdf](Designing.Secure.Software-2021-10.pdf) | 18 | [Chapter 10](chapter-10.md) |
| S12 | 12 | [Designing.Secure.Software-2021-12.pdf](Designing.Secure.Software-2021-12.pdf) | 16 | [Chapter 12](chapter-12.md) |
| S13 | 13 | [Designing.Secure.Software-2021-13.pdf](Designing.Secure.Software-2021-13.pdf) | 12 | [Chapter 13](chapter-13.md) |

## Coverage and review

- All eight supplied PDFs and all 129 pages are included in numeric chapter order.
- Chapters 2, 3, 4, 6, 7, 10, 12, and 13 were supplied. Chapters 1, 5, 8, 9, and 11 are absent; no empty chapter files were created.
- Six numbered figures retain their captions and numbers in source-referenced placeholders. Eight additional placeholders represent decorative chapter-opening artwork without reusing figure numbers.
- Tables 2-1 and 4-1 are converted to Markdown, including all six STRIDE rows and both API comparison rows.
- Source wording, examples, and epigraphs are retained. Code is fenced, inline code is marked, and running footers are omitted. Wingdings numbered callouts are rendered as bracketed numbers.
- Every chapter has one top-level chapter heading and one source section. Source/page markers preserve traceability throughout the extraction.
