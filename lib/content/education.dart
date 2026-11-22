/// Bundled education content. No network calls.
///
/// Each card has:
///  - short `summary` for grid/list views
///  - longer `body` for the detail screen
///  - `keyPoints` for the "Top things to know" section
///  - `category` for section grouping on the Insights tab
class EducationCard {
  const EducationCard({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.keyPoints,
    required this.category,
    required this.readMinutes,
  });

  final String id;
  final String title;
  final String summary;
  final String body;
  final List<String> keyPoints;

  /// 'hormones' | 'metabolism' | 'mental' | 'cycle' | 'care'
  final String category;
  final int readMinutes;
}

const List<EducationCard> educationCards = [
  // ── Hormones / PCOS 101 ───────────────────────────────────
  EducationCard(
    id: 'pcos-overview',
    title: 'PCOS diagnosis and treatment',
    summary:
        'A short, honest explanation of what PCOS actually means — and what it does not.',
    body: 'PCOS is a common hormonal condition that affects how the ovaries '
        'work. It often involves higher levels of androgens (hormones like '
        'testosterone), irregular periods, and sometimes small cysts on the '
        'ovaries. It is not caused by anything you did, and it is not a '
        'personal failing.\n\n'
        'Diagnosis usually involves a combination of symptoms, blood work, '
        'and sometimes an ultrasound, interpreted by a clinician. There is '
        'no single test that confirms PCOS, and there is no cure — but there '
        'are many ways to manage symptoms and protect long-term health.',
    keyPoints: [
      'PCOS is a common disorder, but often goes undiagnosed for years.',
      'Symptoms include irregular periods, hair growth on the face and body, '
          'acne, and sometimes infertility and weight change.',
      'It is manageable. Lifestyle changes and medical care can reduce '
          'symptoms and long-term health risks.',
      'The exact cause is not known. It is associated with insulin '
          'resistance and inflammation, and may involve a mix of genetic '
          'and environmental factors.',
    ],
    category: 'hormones',
    readMinutes: 4,
  ),
  EducationCard(
    id: 'irregular-cycles',
    title: 'What is an irregular menstrual cycle?',
    summary: 'Healthcare providers use this term to describe a cycle that '
        'continually falls outside of "regular." Here is what that means.',
    body:
        'In a typical cycle, the ovaries release an egg about halfway through '
        '(ovulation), and this sets off a chain of hormonal events that '
        'leads to a period roughly two weeks later. In PCOS, ovulation can '
        'be less predictable or less frequent.\n\n'
        'When ovulation does not happen, the hormonal signal that triggers a '
        'period is weaker, so periods may be spaced further apart, lighter, '
        'heavier, or sometimes skip entirely. This is why tracking ranges — '
        'not exact dates — is more useful. A 35-day, 45-day, or 60-day cycle '
        'can all be normal for the same person.',
    keyPoints: [
      'Cycle length can vary between 21 and 35 days in a "typical" cycle. '
          'Anything consistently outside that range is called irregular.',
      'Irregularity does not mean something is wrong with you. It is one '
          'of many ways bodies work.',
      'PCOS is one common cause, but not the only one — stress, thyroid '
          'conditions, and other factors can contribute.',
      'Bring a record of your cycles to appointments to help clinicians '
          'see patterns instead of single data points.',
    ],
    category: 'cycle',
    readMinutes: 3,
  ),
  EducationCard(
    id: 'insulin-resistance',
    title: 'Insulin resistance, explained gently',
    summary:
        'Why blood sugar matters in PCOS — without the diet-culture baggage.',
    body: 'Insulin is a hormone that helps your cells use sugar for energy. In '
        'PCOS, the body often needs more insulin than usual to do the same '
        'job. This is called insulin resistance, and it is very common in '
        'PCOS — not a sign that you have done something wrong.\n\n'
        'Higher insulin can nudge the ovaries to make more androgens, which '
        'can worsen symptoms like acne and irregular periods. Movement, '
        'sleep, stress, and food patterns can all influence insulin '
        'sensitivity. Small, sustainable changes are more useful than '
        'extreme diets.',
    keyPoints: [
      'Insulin resistance is very common in PCOS. It is a body chemistry '
          'pattern, not a personal failure.',
      'It can worsen symptoms like acne and irregular periods.',
      'Movement, sleep, stress, and food patterns all influence insulin '
          'sensitivity — in both directions.',
      'A clinician can help decide whether specific tests are worth doing '
          'for your case.',
    ],
    category: 'metabolism',
    readMinutes: 4,
  ),
  EducationCard(
    id: 'movement',
    title: 'Movement that actually fits PCOS',
    summary:
        'What the research suggests about exercise — and why "just do more '
        'cardio" is bad advice.',
    body: 'Any movement you enjoy and can sustain is valuable. Strength '
        'training in particular has been studied for its effect on insulin '
        'sensitivity and body composition in PCOS. Walking, cycling, '
        'swimming, and dancing all count.\n\n'
        'The goal is not to burn off calories or earn food — it is to support '
        'your muscles, your mood, and your metabolic health. Two to three '
        'short sessions per week is a meaningful start. Rest days are part '
        'of the plan, not a failure of it.',
    keyPoints: [
      'Any movement you can sustain is useful. Consistency beats intensity.',
      'Strength training has been studied for its effect on insulin '
          'sensitivity in PCOS.',
      'Two to three short sessions per week is a meaningful start.',
      'Rest days are part of the plan, not a failure of it.',
    ],
    category: 'metabolism',
    readMinutes: 3,
  ),
  EducationCard(
    id: 'sleep-and-hormones',
    title: 'Sleep and your hormones',
    summary:
        'Short sleep does not cause PCOS, but it does make symptoms harder to '
        'manage.',
    body: 'Sleep is when the body restores hormones, including insulin and '
        'cortisol. Repeated short or poor sleep is associated with higher '
        'insulin resistance, stronger cravings, and lower mood in PCOS.\n\n'
        'None of that means you caused your PCOS by sleeping badly. It means '
        'sleep is one of several levers worth protecting. A consistent '
        'bedtime, a dark room, and limiting screens before bed are small, '
        'low-cost places to start.',
    keyPoints: [
      'Sleep restores hormones, including insulin and cortisol.',
      'Poor sleep is associated with stronger cravings and lower mood in '
          'PCOS.',
      'A consistent bedtime and a dark, cool room are small, low-cost '
          'places to start.',
      'If sleep is persistently difficult, it is worth raising with a '
          'clinician — sleep problems are treatable.',
    ],
    category: 'metabolism',
    readMinutes: 3,
  ),

  // ── Mental health ────────────────────────────────────────
  EducationCard(
    id: 'mental-health',
    title: 'Mental health is part of PCOS care',
    summary: 'Anxiety, low mood, and body image concerns are common — and '
        'treatable.',
    body: 'Research consistently shows higher rates of anxiety and depression '
        'in people with PCOS compared to the general population. This is '
        'partly hormonal, partly the result of living with a chronic '
        'condition, and partly the result of navigating a world that is '
        'often unkind about bodies.\n\n'
        'None of it is all in your head. Therapy, peer support, and — when '
        'appropriate — medication are all valid options. Mental health care '
        'is PCOS care.',
    keyPoints: [
      'Anxiety and depression are more common in people with PCOS.',
      'This is partly hormonal, partly situational — not a weakness.',
      'Therapy, peer support, and medication are all valid options.',
      'Mental health care is a normal part of PCOS care, not a separate '
          'concern.',
    ],
    category: 'mental',
    readMinutes: 3,
  ),
  EducationCard(
    id: 'body-image',
    title: 'Body image, gently',
    summary: 'Visible symptoms like acne and hair change how you see yourself. '
        'That is real, and it is not your fault.',
    body: 'PCOS is often visible. Acne, hair growth on the face and body, hair '
        'thinning on the scalp — these are not private symptoms. They affect '
        'how you see yourself and how you feel in the world.\n\n'
        'Body image distress is a real clinical concern, not a vanity issue. '
        'If it is affecting your mood, your relationships, or your willingness '
        'to leave the house, that is worth talking about with a clinician '
        'or therapist who understands PCOS.',
    keyPoints: [
      'Visible symptoms like acne and hair changes are common and valid.',
      'Body image distress is a clinical concern, not vanity.',
      'If it is affecting mood or daily life, it is worth professional '
          'support.',
      'You are allowed to want to feel at home in your body.',
    ],
    category: 'mental',
    readMinutes: 3,
  ),
  EducationCard(
    id: 'support-network',
    title: 'Building support that actually supports',
    summary: 'How to find people who get it — and what to do when they do not.',
    body:
        'Living with a chronic condition is easier with people who understand '
        'it. Peer communities, online or in person, can offer practical '
        'tips and emotional relief.\n\n'
        'At the same time, not every space labeled "PCOS support" is kind. '
        'Some are full of rigid diet rules or shame. Look for spaces that '
        'respect variation, acknowledge mental health, and do not sell you '
        'a product.',
    keyPoints: [
      'Peer communities can offer practical tips and emotional relief.',
      'Not every "PCOS support" space is kind — watch for shame, rigid '
          'diet rules, and products being sold.',
      'Look for spaces that respect variation and acknowledge mental '
          'health.',
      'You are allowed to set boundaries with people who minimize your '
          'experience.',
    ],
    category: 'mental',
    readMinutes: 3,
  ),

  // ── Cycle deeper dive ────────────────────────────────────
  EducationCard(
    id: 'spotting-vs-period',
    title: 'Spotting vs period vs bleeding',
    summary:
        'Spotting or bleeding can happen anytime, from the time you get your '
        'period to right before you give birth.',
    body: 'Spotting is light bleeding that is not a full period. It is often '
        'just a few drops, sometimes brown, sometimes pink, and usually does '
        'not require a pad or tampon.\n\n'
        'A period is the bleeding that follows ovulation in a typical cycle. '
        'It is usually heavier than spotting and lasts several days.\n\n'
        'Bleeding between periods or after sex can have many causes — some '
        'benign, some worth investigating. If you notice a change from your '
        'usual pattern, especially new bleeding after sex or after '
        'menopause, bring it up with a clinician.',
    keyPoints: [
      'Spotting is light bleeding outside of a full period. It is common '
          'and often harmless.',
      'A period follows ovulation in a typical cycle. It is usually '
          'heavier and lasts several days.',
      'Bleeding after sex, after menopause, or a new change from your '
          'usual pattern is worth raising with a clinician.',
      'Tracking when spotting happens helps a clinician understand what '
          'might be going on.',
    ],
    category: 'cycle',
    readMinutes: 3,
  ),
  EducationCard(
    id: 'cycle-phases',
    title: 'The four phases of a cycle',
    summary:
        'What is actually happening, phase by phase — and why PCOS changes '
        'the timing.',
    body: 'A menstrual cycle has four phases: menstrual (bleeding), follicular '
        '(the ovary preparing an egg), ovulation (the egg is released), and '
        'luteal (the post-ovulation phase).\n\n'
        'In PCOS, ovulation can be delayed, irregular, or absent. When '
        'ovulation does not happen, the luteal phase does not start, and '
        'the follicular phase can continue for weeks or months. This is why '
        'cycles can be much longer than the "typical" 28 days — and why '
        'calendar-based predictions of ovulation and periods often fail in '
        'PCOS.',
    keyPoints: [
      'A typical cycle has four phases: menstrual, follicular, ovulation, '
          'and luteal.',
      'In PCOS, ovulation can be delayed, irregular, or absent.',
      'Without ovulation, the follicular phase can continue for weeks or '
          'months.',
      'This is why calendar predictions for ovulation often fail in PCOS. '
          'Ranges are more honest.',
    ],
    category: 'cycle',
    readMinutes: 4,
  ),
  EducationCard(
    id: 'talking-to-doctor',
    title: 'Preparing for a PCOS appointment',
    summary: 'What to bring, what to ask, and how to be taken seriously.',
    body: 'Bring a record of your recent cycles (start dates are most useful), '
        'any symptoms you have been tracking, and a list of medications and '
        'supplements. Write down your top three questions before the visit '
        '— it is easy to forget them in the room.\n\n'
        'If you feel dismissed, you are allowed to ask "What else could '
        'this be?" or to seek a second opinion. You are not being '
        'difficult; you are being your own advocate.',
    keyPoints: [
      'Bring a record of cycle start dates, symptoms, and medications.',
      'Write down your top three questions before the visit.',
      'If you feel dismissed, you are allowed to ask what else it could be, '
          'or to seek a second opinion.',
      'The Lunora PDF report is designed to make this conversation easier.',
    ],
    category: 'care',
    readMinutes: 3,
  ),

  // ── Visible symptoms ────────────────────────────────────
  EducationCard(
    id: 'acne-and-hair',
    title: 'Acne, excess hair, and hair thinning',
    summary: 'The visible symptoms of PCOS — and why they are not your fault.',
    body: 'Higher androgen levels in PCOS can cause acne (especially along the '
        'jawline and chin), increased facial or body hair (hirsutism), and '
        'thinning hair on the scalp.\n\n'
        'These symptoms are driven by hormones, not by hygiene or willpower. '
        'They are also among the most distressing for many people, which is '
        'worth naming. Treatments exist — from topical creams to hormonal '
        'options to cosmetic approaches like laser — but they need a '
        'clinician who takes your concerns seriously.',
    keyPoints: [
      'Higher androgens can cause acne, hirsutism, and hair thinning on '
          'the scalp.',
      'These symptoms are driven by hormones, not hygiene or willpower.',
      'They are among the most distressing for many people — that is real.',
      'Treatments exist. They need a clinician who takes your concerns '
          'seriously.',
    ],
    category: 'hormones',
    readMinutes: 3,
  ),
  EducationCard(
    id: 'weight-and-pcos',
    title: 'Weight, PCOS, and the myth of "just lose weight"',
    summary: 'Why the advice is more complicated than a number on a scale.',
    body: 'Weight and PCOS are related, but not in the simple way the internet '
        'often claims. PCOS can make weight changes harder because of insulin '
        'resistance and hormonal shifts. Weight changes can, in turn, affect '
        'PCOS symptoms. This is a two-way street, not a personal failing.\n\n'
        'Weight-neutral approaches — focusing on movement, sleep, stress, '
        'and sustainable eating patterns rather than a target number — are '
        'increasingly supported in clinical guidance.',
    keyPoints: [
      'Weight and PCOS interact in both directions.',
      'PCOS can make weight changes harder. That is biology, not willpower.',
      'Weight-neutral approaches are increasingly supported in clinical '
          'guidance.',
      'You do not have to shrink to deserve care.',
    ],
    category: 'metabolism',
    readMinutes: 4,
  ),

  // ── Care / meds ─────────────────────────────────────────
  EducationCard(
    id: 'meds-common',
    title: 'Common PCOS medications, at a glance',
    summary:
        'What different medication classes are usually for — no dosing advice.',
    body: 'Several medication classes are commonly discussed in PCOS care. '
        'Metformin is sometimes used to support insulin sensitivity. '
        'Inositol is a supplement often discussed in the same context. '
        'Spironolactone is sometimes used for androgen-related symptoms. '
        'Combined hormonal birth control is often used to regulate cycles '
        'and reduce androgens.\n\n'
        'Your clinician may recommend none, one, or a combination — there '
        'is no universal protocol. Lunora tracks whatever you are on, but '
        'it does not recommend doses or changes.',
    keyPoints: [
      'Different medication classes serve different goals in PCOS care.',
      'There is no universal protocol — your clinician tailors it to you.',
      'Lunora tracks what you are on. It does not recommend doses or '
          'changes.',
      'Talk to your prescriber before starting, stopping, or changing any '
          'medication.',
    ],
    category: 'care',
    readMinutes: 4,
  ),
  EducationCard(
    id: 'nutrition-honest',
    title: 'Nutrition, without the diet-culture noise',
    summary: 'What actually helps with PCOS eating — and what to ignore.',
    body: 'There is no single "PCOS diet." The strongest evidence points to '
        'eating patterns that support steady blood sugar: including protein '
        'and fiber at meals, not skipping meals if that leaves you ravenous '
        'later, and eating enough overall.\n\n'
        'Restrictive diets often backfire because they are hard to sustain '
        'and can worsen the stress and cravings they try to fix. Food is '
        'not a moral issue.',
    keyPoints: [
      'There is no single "PCOS diet." Be wary of anyone who says there is.',
      'Protein and fiber at meals, and eating enough overall, help support '
          'steady blood sugar.',
      'Restrictive diets often backfire — they are hard to sustain.',
      'Food is not a moral issue.',
    ],
    category: 'metabolism',
    readMinutes: 3,
  ),
  EducationCard(
    id: 'fertility-basics',
    title: 'PCOS and fertility, honestly',
    summary: 'PCOS can affect fertility — but it does not mean you cannot get '
        'pregnant.',
    body: 'Because ovulation can be irregular or absent in PCOS, getting '
        'pregnant can take longer for some people. This does not mean you '
        'cannot get pregnant.\n\n'
        'Many people with PCOS conceive naturally, and many more with '
        'medical support. If you are trying to conceive and want help, there '
        'are effective treatments — from ovulation-inducing medications to '
        'IVF — and clinicians who specialize in PCOS and fertility.\n\n'
        'Lunora is not a fertility tool. It does not predict ovulation or '
        'fertile windows. If you are trying to conceive, work with a '
        'clinician.',
    keyPoints: [
      'Irregular ovulation can make conception take longer in PCOS.',
      'Many people with PCOS conceive naturally, and many more with '
          'medical support.',
      'Effective treatments exist. Ask a clinician who specializes in '
          'PCOS and fertility.',
      'Lunora is not a fertility tool. It does not predict ovulation or '
          'fertile windows.',
    ],
    category: 'care',
    readMinutes: 4,
  ),
];
