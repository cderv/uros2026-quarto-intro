# Public repository

Talk repositories are usually public. Decide at write time what belongs here: cleaning up after
publication is far more expensive.

Never commit:

- braid strand IDs (`br-...`) or other tracker IDs in files or commit messages;
- notes about named people (organizers, reviewers, attendees), private correspondence, or private
  links;
- review reports, transcripts, or session URLs;
- secrets or tokens.

Keep working notes in braid comments instead. Before making a repository public, check every
branch with `git ls-remote origin`, not only `main`.
