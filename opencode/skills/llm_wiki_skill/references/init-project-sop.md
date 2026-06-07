# Project Initialization SOP

## Goal

Create a knowledge base for the current project, scan the project structure, and generate overview, architecture, entities, and other pages.

## Prerequisites

- Current working directory is the project root
- wiki-schema.md has been read to understand templates and conventions

## Steps

### Step 1: Determine Project Information

1. Use the bash tool to get the current directory name as the default project name:

   ```bash
   basename $(pwd)
   ```

2. Convert the project name to kebab-case (e.g., MyApp → my-app)
3. Check if `~/.llm-wiki/projects/{project-name}/` already exists:

   ```bash
   ls ~/.llm-wiki/projects/{project-name}/ 2>/dev/null && echo "EXISTS" || echo "NEW"
   ```

4. If it already exists, ask the user whether to reinitialize or update

### Step 1b: Determine Wiki Language (CRITICAL)

**Before generating any content, you MUST determine the language for the wiki.**

**How to determine the language:**
1. Analyze the conversation context:
   - What language is the user currently using?
   - What language are the project's README/comments written in?
   - What language are existing documents (if any) written in?
2. Propose a default language based on context
3. **Ask the user to confirm or change it**

**Example dialogue:**
```
Agent: Based on our conversation, I suggest writing the wiki in **English**.
Would you like to use English, or would you prefer another language (e.g., 中文, Español)?

User: English is fine / Let's use 中文
```

**Storage:**
- Store the confirmed language in `~/.llm-wiki/projects/{project-name}/.config`
- Format: `lang: en` (ISO 639-1 code)
- Also add to overview.md frontmatter: `lang: en`

**Enforcement:**
- ALL subsequent wiki operations for this project MUST use this language
- This includes: entity pages, change records, analyses, sources, decisions
- If the user later wants to change the language, they must explicitly request it

**Why mandatory?**
- Consistency: Mixed languages in a wiki make it unreadable and hard to search
- Query accuracy: The query SOP relies on language-consistent content
- User experience: Users expect the wiki to match their preferred language

### Step 2: Scan Project Structure

Use the bash tool to get the project file tree:

```bash
find . -type f \
  -not -path "*/node_modules/*" \
  -not -path "*/.git/*" \
  -not -path "*/vendor/*" \
  -not -path "*/dist/*" \
  -not -path "*/build/*" \
  -not -path "*/.next/*" \
  -not -path "*/coverage/*" \
  -not -path "*/.turbo/*" \
  | sort
```

### Step 3: Read Key Files

Use the read tool to read:
- README.md (project description)
- package.json (Node.js project)
- go.mod (Go project)
- Cargo.toml (Rust project)
- pyproject.toml / requirements.txt (Python project)
- pom.xml / build.gradle (Java project)
- src/ or app/ directory first-level structure

If a file does not exist, skip it.

### Step 4: Analyze and Identify Entities

Based on the content read, analyze:
1. **Project type**: Web backend, frontend, CLI tool, library, etc.
2. **Technology stack**: Programming language, framework, database, middleware
3. **Main modules**: Based on directory structure
4. **Key entities**:
   - Service classes: Handle business logic
   - Controllers: Handle HTTP requests
   - Repositories: Data access
   - Models: Domain models
   - Middleware: Request processing chain
   - Utilities: Helper functions

**Entity identification principles**:
- Prioritize externally exposed modules (API layer, service layer)
- Each entity corresponds to an independent responsibility
- Don't be too granular (e.g., don't treat every util function as an entity)
- Typically 5-15 core entities per project

### Step 5: Generate Wiki Page Content

According to the templates in wiki-schema.md, generate the following content:

**overview.md**:
- Project goal and scope (1-2 sentences)
- Technology stack list (table format)
- Directory structure description
- Team information (if available)

**architecture.md**:
- System-wide description
- Module relationship diagram (text or Mermaid)
- Data flow description
- Key technology choices and reasons

**entities/*.md** (one file per entity):
- Use the entity page template from wiki-schema.md
- Include Source field (pointing to source code file path)
- Include Responsibilities, Dependencies, Interface
- Change History initially empty

**index.md**:
- Use the catalog template from wiki-schema.md
- List all generated pages

**log.md**:
- Initial content: "# Log\n\n## [time] init | {project-name}\nInitialized project wiki."

### Step 6: Collaborative Confirmation

Show the user a summary:

```
I will create a knowledge base for {project-name}, containing:

📄 overview.md — Project overview and tech stack
📄 architecture.md — Architecture description and module relationships
📄 entities/ — {N} entity pages:
  - [[Entity1]] — {Responsibility}
  - [[Entity2]] — {Responsibility}
  ...

Is this accurate? What needs to be adjusted?
(For example: "focus on auth module", "skip deprecated services", "add X entity")
```

Adjust based on user feedback:
- Add/remove entities
- Adjust description focus
- Modify tech stack information

### Step 7: Write Files

Use the write tool to create the following files:

1. `~/.llm-wiki/projects/{project-name}/index.md`
2. `~/.llm-wiki/projects/{project-name}/log.md`
3. `~/.llm-wiki/projects/{project-name}/overview.md`
4. `~/.llm-wiki/projects/{project-name}/architecture.md`
5. `~/.llm-wiki/projects/{project-name}/entities/index.md`
6. `~/.llm-wiki/projects/{project-name}/entities/{entity-name}.md` (for each entity)
7. Create empty directories: `changes/`, `sources/`, `decisions/`, `api/`, `analyses/`

### Step 8: Git Init and Commit

Use the bash tool:

```bash
cd ~/.llm-wiki/
git init 2>/dev/null || true
git add -A
git commit -m "[$(date +%Y-%m-%d\ %H:%M)] init | {project-name}"
```

### Step 9: Update Global Index

1. Use the read tool to read `~/.llm-wiki/global/projects-index.md`
2. If it does not exist, create this file first
3. Use the edit tool to add the new project:
   `- [{project-name}](projects/{project-name}/index.md) — {One-line description}`
4. Use the bash tool to commit:

```bash
cd ~/.llm-wiki/ && git add -A && git commit -m "[$(date +%Y-%m-%d\ %H:%M)] update-index | add {project-name}"
```

### Step 10: Report Results

Report to the user:
- Created {N} pages
- Suggest reading overview.md and architecture.md first
- Changes will be automatically prompted for recording during subsequent development

## FAQ

**Q: How is the project name determined?**
A: Priority is given to the name field in package.json/go.mod, followed by the current directory name (kebab-case).

**Q: What if entity identification is inaccurate?**
A: During the collaborative confirmation phase, the user can adjust the entity list. The Agent should modify accordingly.

**Q: What if the project has no README?**
A: Infer the project type and purpose based on directory structure and code files.

**Q: Will reinitializing overwrite existing content?**
A: Ask the user. If choosing to reinitialize, you can back up the old directory (rename) or perform an incremental update.
