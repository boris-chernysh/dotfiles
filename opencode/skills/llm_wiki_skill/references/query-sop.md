# Technical Query SOP

## Goal

Answer the user's technical questions based on Wiki knowledge, with support for answer filing.

## Prerequisites

- wiki-schema.md has been read to understand templates and conventions
- Project knowledge base has been initialized

## Steps

### Step 0: Check Wiki Language

Before generating any content, read the language configuration:

```bash
cat ~/.llm-wiki/projects/{project-name}/.config 2>/dev/null || echo "lang: en"
```

**The answer MUST be in the wiki language.** If the user asks in a different language, translate the wiki content to the user's language in your response, but file any saved analysis in the wiki language.

### Step 1: Understand User Question

Analyze the type of user question:
- **Factual query**: "How does X work" → Find entity pages
- **Reason query**: "Why designed this way" → Find decisions/ and entity pages
- **Relationship query**: "Relationship between X and Y" → Find multiple entities, analyze dependencies
- **Comparison query**: "Difference between X and Y" → Find multiple entities, compare and analyze
- **Flow query**: "How does data flow" → Find architecture.md and entity pages

### Step 2: Search Relevant Pages

**Preferred method**: Read the project index.md

```bash
read ~/.llm-wiki/projects/{project-name}/index.md
```

Find relevant page links from index.md.

**Alternative method**: If index.md information is insufficient, use grep to search

```bash
grep -r "keyword" ~/.llm-wiki/projects/{project-name}/ --include="*.md" -l
```

**Global search**: If the question involves cross-project concepts, also search the global/ directory:

```bash
grep -r "keyword" ~/.llm-wiki/global/ --include="*.md" -l
```

### Step 3: Read Relevant Pages

Use the read tool to read searched pages one by one.

**Reading priority**:
1. Directly relevant entity pages
2. architecture.md (if architecture is involved)
3. decisions/ (if design decisions are involved)
4. global/concepts/ or global/technologies/ (if general concepts are involved)

**Reading strategy**:
- Simple question: Read 1-2 pages
- Complex question: Read 3-5 pages
- If there are many pages, first read index.md to determine the most relevant 3

### Step 4: Synthesize Answer

Based on the content read, synthesize an answer to the user's question.

**Answer structure**:
1. **Direct answer**: Give a one-sentence summary first
2. **Detailed explanation**: Expand the explanation
3. **Cite sources**: Use `[[page-name]]` to label information sources
4. **Related links**: Mention other related entities/pages

**Citation format**:
```markdown
> Sources: [[entities/AuthService]], [[architecture]], [[decisions/2026-04-22-adopt-kafka]]
```

**If information is insufficient**:
- Inform the user: "Information about X in the knowledge base is limited, currently only found..."
- Suggest: "You can supplement relevant documents to the sources/ directory"

### Step 5: Determine if Filing is Needed

If the answer meets the following conditions, it should be filed back into the Wiki:
- Contains new **comprehensive analysis** (not simple factual restatement)
- Contains **comparison** (comparison of two entities)
- Contains **flow analysis** (data flow across multiple entities)
- Contains **design suggestions** or **best practices**
- User explicitly says "I might ask this again in the future"

**Do not file**:
- Simple factual queries ("What parameters does this function take")
- Questions whose answers can be directly obtained from a single page
- Temporary, project-specific questions

### Step 6: Ask User if They Want to File (if needed)

```
This analysis involves synthesis across multiple entities. Would you like to save it to the knowledge base for future reuse?

Will save to: analyses/{title}.md

Contains:
- {Summary}
```

If the user confirms:
1. Use the write tool to create analyses/{title}.md
2. Use the analysis page template from wiki-schema.md
3. Use the edit tool to update index.md (add link in the Analyses section)
4. Use the bash tool to execute git commit

### Step 7: Record Log

Use the edit tool to append to log.md:

```markdown
## [YYYY-MM-DD HH:MM] query | "{user question}"
Answered using: {list of cited pages}
Saved to: {path if filed}
```

## Query Examples

**User asks**: "How does AuthService do permission verification?"

**Agent executes**:
1. Read index.md → Find entities/AuthService.md
2. Read entities/AuthService.md → Understand responsibilities and interface
3. May also read api/auth.md → Understand API-level auth
4. Synthesize answer:
   ```
   AuthService uses JWT for permission verification:
   1. Extract Bearer token from request header
   2. Use jwt.verify() to verify signature and expiration
   3. Get userId and roles from token payload
   4. Query database to confirm user status and permissions
   
   Key interfaces:
   - validateToken(token: string): Promise<TokenPayload>
   - checkPermission(userId: string, resource: string): Promise<boolean>
   
   > Sources: [[entities/AuthService]], [[api/auth]]
   ```

**User asks**: "What is the order creation flow?"

**Agent executes**:
1. Read architecture.md → Understand overall data flow
2. Read entities/OrderService.md → Understand order service
3. Read entities/PaymentService.md → Understand payment service
4. Read entities/InventoryService.md → Understand inventory service
5. Synthesize answer (flow is long, suitable for filing to analyses/order-creation-flow.md)

## FAQ

**Q: What if relevant information cannot be found?**
A: Inform the user that the knowledge base has insufficient information and suggest supplementing sources/ or initializing the project wiki.

**Q: What if information is contradictory?**
A: Point out the contradiction ("architecture.md says use Kafka, but entities/OrderService.md says use RabbitMQ"), and ask the user which is correct.

**Q: How long should the answer be?**
A: Depends on question complexity. Simple questions: 2-3 sentences. Complex questions: can be longer, but structured (lists, sections).
