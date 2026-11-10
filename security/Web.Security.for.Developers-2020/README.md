# Extraction index

The supplied filenames use `Title-Year-Chapter.pdf`, rather than the plan’s chapter-section suffix. Each PDF is treated as one chapter source. Section headings use the cleaned filename prefix. Source IDs below identify figure, table, and page references; PDF pages are numbered from 1 within each file.

| Source ID | Chapter | Source PDF | Pages | Markdown |
| --- | --- | --- | --- | --- |
| S6 | 6 | [Web.Security.for.Developers-2020-6.pdf](Web.Security.for.Developers-2020-6.pdf) | 16 | [Chapter 6](chapter-06.md) |
| S7 | 7 | [Web.Security.for.Developers-2020-7.pdf](Web.Security.for.Developers-2020-7.pdf) | 11 | [Chapter 7](chapter-07.md) |
| S8 | 8 | [Web.Security.for.Developers-2020-8.pdf](Web.Security.for.Developers-2020-8.pdf) | 6 | [Chapter 8](chapter-08.md) |
| S9 | 9 | [Web.Security.for.Developers-2020-9.pdf](Web.Security.for.Developers-2020-9.pdf) | 12 | [Chapter 9](chapter-09.md) |
| S10 | 10 | [Web.Security.for.Developers-2020-10.pdf](Web.Security.for.Developers-2020-10.pdf) | 10 | [Chapter 10](chapter-10.md) |
| S11 | 11 | [Web.Security.for.Developers-2020-11.pdf](Web.Security.for.Developers-2020-11.pdf) | 10 | [Chapter 11](chapter-11.md) |
| S12 | 12 | [Web.Security.for.Developers-2020-12.pdf](Web.Security.for.Developers-2020-12.pdf) | 4 | [Chapter 12](chapter-12.md) |
| S14 | 14 | [Web.Security.for.Developers-2020-14.pdf](Web.Security.for.Developers-2020-14.pdf) | 14 | [Chapter 14](chapter-14.md) |
| S15 | 15 | [Web.Security.for.Developers-2020-15.pdf](Web.Security.for.Developers-2020-15.pdf) | 8 | [Chapter 15](chapter-15.md) |
| S16 | 16 | [Web.Security.for.Developers-2020-16.pdf](Web.Security.for.Developers-2020-16.pdf) | 9 | [Chapter 16](chapter-16.md) |
| S17 | 17 | [Web.Security.for.Developers-2020-17.pdf](Web.Security.for.Developers-2020-17.pdf) | 6 | [Chapter 17](chapter-17.md) |

## Coverage and review

- All 11 supplied PDFs and all 106 pages are included, in numeric chapter order.
- Chapters 6–12 and 14–17 were supplied. Chapters 1–5 and 13 are absent; no empty chapter files were created.
- The chapter 7 PDF begins with printed page 64 from chapter 6. That page is retained and explicitly identified in chapter-07.md.
- All 11 numbered figures have placeholders retaining their original captions and source/page references.
- Chapter-opening decorative artwork is represented by one placeholder per opening page, covering nine image tiles each (99 tiles total).
- Table 7-1 is converted to Markdown with all five data rows; HTML entities are escaped so their literal spellings remain visible.
- Code listings are fenced and inline code is marked. Wingdings numbered callouts are rendered as bracketed numbers. Running page footers are omitted. The historical wording is retained, without updating technical claims.
- Generated decorative-artwork labels do not reuse source figure numbers. Every chapter has one top-level chapter heading and one source section.
