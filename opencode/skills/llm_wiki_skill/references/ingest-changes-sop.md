# Change Ingestion SOP

## Goal

Analyze recent code changes (commits), update relevant entity pages, and create change records.

## Prerequisites

- Current working directory is the project root (has .git directory)
- Project has been initialized in ~/.llm-wiki/projects/{project-name}/
- wiki-schema.md has been read to understand templates and conventions

## Steps

### Step 0: Check Wiki Language

Before generating any content, read the language configuration:

```bash
cat ~/.llm-wiki/projects/{project-name}/.config 2>/dev/null || echo "lang: en"
```

**All generated content MUST use this language.** This includes:
- Change History entries in entity pages
- Change record pages in `changes/`
- Log entries

If no config exists, default to English and create the config file.

### Step 1: Get Change Information

Use the bash tool to get information about the latest commit:

```bash
# Get commit message
git log -1 --pretty=format:"%H|%s|%b"

# Get change stats
git diff HEAD~1 --stat

# Get full diff (if not too large)
git diff HEAD~1
```

**If the diff is too large** (> 100 lines), only get stats:

```bash
git diff HEAD~1 --stat
```

Then selectively read the content of changed files instead of the entire diff.

### Step 2: Parse Commit Message

Extract the following information:
- **Hash**: commit hash (first 7 characters are sufficient)
- **Subject**: commit subject
- **Body**: commit body (if any)
- **Type**: If it's a conventional commit, extract the type (feat/fix/refactor/docs/chore)
- **Scope**: If it's a conventional commit, extract the scope

**Conventional Commit format**:
```
<type>(<scope>): <subject>

<body>
```

For example: `feat(auth): migrate to JWT`
- type: feat
- scope: auth
- subject: migrate to JWT

### Step 3: Identify Affected Entities

1. Get the list of changed files from `git diff --stat`
2. Map file paths to entities:
   - `src/auth/service.ts` → [[AuthService]]
   - `src/user/repository.ts` → [[UserRepository]]
   - `src/middleware/auth.ts` → [[AuthMiddleware]]
3. If a file corresponds to a new entity, mark it as "new"
4. If a file corresponds to an existing entity, mark it as "updated"

**Mapping rules**:
- Prefer inference from file names (service → Service, controller → Controller)
- If unable to infer, check the class/function name in the file
- If still uncertain, ask the user during collaborative confirmation

### Step 4: Analyze Change Nature

For each affected entity, determine the nature of the change:

| Change Type | Determination Basis | Action |
|-------------|---------------------|--------|
| Interface change | Function signature changes, methods added/removed | Update entity's Interface section |
| New entity | New file, new class | Create new entity page |
| Architecture adjustment | New module, directory structure change | Update architecture.md |
| Dependency change | Import changes, new dependencies introduced | Update entity's Dependencies |
| Bug fix | fix type commit | Note in Change History |
| Refactoring | refactor type | Explain refactoring content in Change History |

### Step 5: Read Existing Entity Pages

Use the read tool to read entity pages that need to be updated:

```
~/.llm-wiki/projects/{project-name}/entities/{entity-name}.md
```

### Step 6: Update Entity Pages

Use the edit tool to update:

1. **Update Last Updated**: Change `> **Last Updated**: {old date}` to today
2. **Update Source**: If source files have changed, update the commit hash in the Source field
3. **Append Change History**: Append at the bottom of the Change History section:

```markdown
### {YYYY-MM-DD} — {change title}
{Change description}

- Commit: `{hash}`
- Type: {feat|fix|refactor|docs}
- Files: `{file1}`, `{file2}`
```

4. **Update Interface** (if interface changed): Update function signatures, parameters, return values
5. **Update Dependencies** (if dependencies changed): Add/remove Uses or Used by

### Step 7: Create New Entity Pages (if new entities exist)

Use the write tool to create new pages according to the entity page template in wiki-schema.md.

### Step 8: Create Change Record Page

Use the write tool to create a new file in `changes/`:

File name: `changes/YYYY-MM-DD-{short-desc}.md`

Content uses the change record template from wiki-schema.md.

### Step 9: Update index.md

Use the edit tool to update the project's index.md:
- Add new change record link in the Changes section
- Add to the Entities section if there are new entities

### Step 10: Collaborative Confirmation

Show the user a change summary:

```
Detected change: {commit subject}

Impact analysis:
- Changed files: {file1}, {file2}, ...
- Affected entities:
  - [[EntityA]] — {Brief update description}
  - [[EntityB]] — {Brief update description}
- Will create: changes/{date}-{desc}.md

Is this accurate? What needs to be added?
```

Adjust based on user feedback, then confirm.

### Step 11: Git Commit

Use the bash tool:

```bash
cd ~/.llm-wiki/ && git add -A && git commit -m "[{YYYY-MM-DD HH:MM}] ingest-changes | {project-name}: {summary}"
```

### Step 12: Append Log

Use the edit tool to append to `~/.llm-wiki/projects/{project-name}/log.md`:

```markdown
## [YYYY-MM-DD HH:MM] ingest-changes | commit {hash}
{summary}
Updated: {entity list}
Created: {new entity list}
```

## FAQ

**Q: How to determine which entity a file corresponds to?**
A: Infer from file path and naming. For example, `src/auth/service.ts` usually corresponds to AuthService. If uncertain, ask the user during confirmation.

**Q: What if the change involves a large number of files?**
A: Only focus on core changed files (business logic files), ignore test files, config files, formatting changes, etc. During confirmation, tell the user "I only focused on core changes, need to supplement other files?"

**Q: What if the entity page doesn't exist yet?**
A: Explain that this is a new entity and create a new entity page.

**Q: What if the change is just formatting or refactoring with no functional changes?**
A: Still record it, but briefly explain it's a "code refactoring" or "formatting adjustment".
