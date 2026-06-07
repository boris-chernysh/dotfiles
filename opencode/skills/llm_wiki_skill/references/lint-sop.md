# Health Check SOP

## Goal

Check knowledge base quality, discover contradictions, dead links, orphan pages, and other issues.

## Prerequisites

- wiki-schema.md has been read to understand templates and conventions
- Project knowledge base has been initialized

## Steps

### Step 1: Scan Pages

Use the bash tool to list all pages:

```bash
find ~/.llm-wiki/projects/{project-name} ~/.llm-wiki/global -name "*.md" | sort
```

Count page numbers:

```bash
echo "Total pages: $(find ~/.llm-wiki/projects/{project-name} ~/.llm-wiki/global -name "*.md" | wc -l)"
```

### Step 2: Check Dead Links

**Extract all links**:

```bash
# Extract [[wikilink]] format
grep -rP "\[\[.*?\]\]" ~/.llm-wiki/projects/{project-name} --include="*.md" -o

# Extract [text](path) format
grep -rP "\[.*?\]\(.*?\)" ~/.llm-wiki/projects/{project-name} --include="*.md" -o
```

**Verify target existence**:

For each link:
- `[[EntityName]]` → Check if `entities/entity-name.md` exists
- `[Text](path.md)` → Check if target file exists

**Record dead links**:
- Source page (which file contains the dead link)
- Target path (where it points)
- Severity: error (must fix) / warning (should fix)

### Step 3: Check Orphan Pages

**Count inbound links**:

For each page, calculate how many other pages link to it:

```bash
# Take entities/AuthService.md as an example
grep -r "AuthService" ~/.llm-wiki/projects/{project-name} --include="*.md" -l
```

**Orphan page criteria**:
- Inbound link count is 0 (except for index.md)
- Severity: warning

**Note**: Change record pages (changes/) and Source pages (sources/) usually have few inbound links, which is normal.

### Step 4: Check Empty Pages

Use the bash tool to check page content:

```bash
# Check pages with very little content
find ~/.llm-wiki/projects/{project-name} -name "*.md" -exec wc -l {} \; | sort -n | head -10
```

**Empty page criteria**:
- Less than 5 lines of valid content (excluding frontmatter and headings)
- Severity: warning

### Step 5: Check Source Attribution

Read all entity pages and check if they contain the `> **Source**:` field.

**Missing Source**:
- If entity page has no Source field → error
- If Source field points to a file that no longer exists in the project → warning

### Step 6: Analyze Contradictions (Agent Intelligence)

This part requires Agent intelligence analysis:

1. **Read architecture.md**
2. **Read key entity pages** (5-10 core entities)
3. **Check consistency**:
   - Does the module division described in architecture.md match entities/?
   - Are dependency relationships between entities/ self-consistent?
   - Are technology stack descriptions consistent?

**Common contradiction types**:
| Contradiction | Example | Severity |
|--------------|---------|----------|
| Inconsistent module division | architecture.md says there is OrderService, but entities/ does not have it | error |
| Dependency contradiction | A depends on B, but B's Used by does not have A | warning |
| Tech stack contradiction | overview.md says PostgreSQL, but entities/ says MySQL | error |
| Outdated interface description | entity's Interface does not match actual source code | warning |

### Step 7: Check Update Timeliness

Check the Last Updated field of pages:

```bash
# Extract all Last Updated
grep -r "Last Updated" ~/.llm-wiki/projects/{project-name} --include="*.md"
```

**Outdated criteria**:
- Core entity pages not updated for more than 3 months → warning
- If there have been code changes during this period but wiki was not updated → error

### Step 8: Generate Report

Summarize all issues and generate a report:

```markdown
# Wiki Health Report — {project-name}

> **Date**: {YYYY-MM-DD}

## Summary
- Total Pages: {N}
- Errors: {N}
- Warnings: {N}

## Errors
1. [Dead link] overview.md → [[OldService]] (entity deleted)
2. [Missing Source] entities/PaymentService.md has no Source field
3. [Contradiction] architecture.md says there is InventoryService, but it does not exist in entities/

## Warnings
1. [Orphan] changes/2026-04-01-old.md not referenced by any page
2. [Empty] sources/temp.md only has 3 lines of content
3. [Outdated] entities/UserService.md last updated on 2026-01-01

## Recommendations
- Fix dead links: update overview.md to remove OldService reference
- Add Source: add source code reference for PaymentService
- Sync architecture: create InventoryService entity page or update architecture.md
```

### Step 9: Confirm Fixes with User

Show the report to the user and ask:

```
Found {N} errors and {N} warnings:

[Error list]
[Warning list]

Would you like me to automatically fix them? I can:
- Fix dead links (update/remove broken links)
- Delete empty pages
- Mark orphan pages (add links in index.md)

Or you can tell me which ones to fix and which to ignore.
```

### Step 10: Execute Fixes (based on user confirmation)

Use the edit tool to fix confirmed issues:
- Dead links: update links or remove references
- Empty pages: delete or supplement content
- Orphan pages: add links in index.md
- Missing Source: add Source field

Use the bash tool to commit:

```bash
cd ~/.llm-wiki/ && git add -A && git commit -m "[{YYYY-MM-DD HH:MM}] lint | {project-name}: fix {N} issues"
```

### Step 11: Append Log

Use the edit tool to append to log.md:

```markdown
## [YYYY-MM-DD HH:MM] lint | {project-name}
Checked {N} pages, found {N} errors, {N} warnings.
Fixed: {fix list}
Remaining: {unfixed list}
```

## Checklist

When the Agent executes lint, check against the following list:

- [ ] List all pages
- [ ] Check dead links ([[link]] and [text](path))
- [ ] Check orphan pages (inbound links = 0)
- [ ] Check empty pages (content < 5 lines)
- [ ] Check missing Source fields
- [ ] Check consistency between architecture.md and entities/
- [ ] Check tech stack description consistency
- [ ] Check page update timeliness
- [ ] Generate report
- [ ] Ask user for fix confirmation
- [ ] Execute fixes (after user confirmation)

## FAQ

**Q: How often should lint be run?**
A: Recommended after each large batch of changes, or manually triggered once a week.

**Q: Found contradictions but don't know if the wiki is wrong or the code is wrong?**
A: Code is the source of truth. The wiki is an extraction layer of the code; if there is a contradiction, update the wiki.

**Q: Must orphan pages be fixed?**
A: Not necessarily. Some pages (like change records) naturally have few inbound links. But if a core entity page is orphan, it should be fixed.
