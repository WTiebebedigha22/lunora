enum InsightsEntryType { article, story }

class InsightsEntry {
  const InsightsEntry({
    required this.title,
    required this.summary,
    required this.publisher,
    required this.date,
    required this.url,
    required this.type,
  });

  final String title;
  final String summary;
  final String publisher;
  final String date;
  final String url;
  final InsightsEntryType type;
}

/// A small, source-linked editorial selection. Summaries are paraphrased;
/// open the publisher's page for the full article or personal story.
const latestArticles = <InsightsEntry>[
  InsightsEntry(
    title: 'Updated international guidance for PMOS care',
    summary: 'Monash’s international guideline brings together current evidence and lived experience to support assessment and shared care decisions.',
    publisher: 'Monash Centre for Health Research and Implementation',
    date: '2026',
    url: 'https://www.monash.edu/medicine/mchri/pcos/guideline',
    type: InsightsEntryType.article,
  ),
  InsightsEntry(
    title: 'Why PCOS has a new name: PMOS',
    summary: 'A global consensus paper explains why the condition’s name changed and how the new term reflects its endocrine, metabolic and ovarian features.',
    publisher: 'The Lancet · PubMed',
    date: '12 May 2026',
    url: 'https://pubmed.ncbi.nlm.nih.gov/42119588/',
    type: InsightsEntryType.article,
  ),
  InsightsEntry(
    title: 'Treatment evidence for adolescents: what the review found',
    summary: 'A 2026 systematic review looks at non-hormonal medicines for adolescents; the authors note that the available studies are still limited.',
    publisher: 'Journal of Pediatric and Adolescent Gynecology · PubMed',
    date: 'August 2026',
    url: 'https://pubmed.ncbi.nlm.nih.gov/41506442/',
    type: InsightsEntryType.article,
  ),
];

const realStories = <InsightsEntry>[
  InsightsEntry(
    title: 'Soph: making peace with her body while living with PCOS',
    summary: 'A lived-experience advocate reflects on body image, care that looked beyond weight, and finding movement that felt joyful.',
    publisher: 'Butterfly Foundation',
    date: '29 Aug 2025',
    url: 'https://butterfly.org.au/living-with-pcos-reclaiming-my-body-and-my-joy/',
    type: InsightsEntryType.story,
  ),
  InsightsEntry(
    title: 'Esther: years of irregular bleeding and searching for answers',
    summary: 'Esther shares how her symptoms changed over time, how hard it was to get clear follow-up, and what she wishes she had known.',
    publisher: 'Wellbeing of Women',
    date: '14 Sep 2023',
    url: 'https://www.wellbeingofwomen.org.uk/news/esthers-story-pcos-pushed-me-from-bleeding-for-six-weeks-to-no-period-for-six-months/',
    type: InsightsEntryType.story,
  ),
  InsightsEntry(
    title: 'A first-person account of diagnosis and online misinformation',
    summary: 'A writer describes navigating a diagnosis, conflicting advice and the work of finding information that felt trustworthy.',
    publisher: 'The Guardian',
    date: '22 Jun 2025',
    url: 'https://www.theguardian.com/society/2025/jun/22/i-was-diagnosed-with-pcos-and-was-soon-drowning-in-misinformation',
    type: InsightsEntryType.story,
  ),
];
