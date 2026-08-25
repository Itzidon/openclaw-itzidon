# TOOLS.md - Connected Tools and Conventions

## General Rule

Use the tool that best matches the task.

Before performing an external action, verify the relevant details and follow the confirmation rules defined in AGENTS.md.

Never store passwords, API keys, tokens or credentials in this file.

## Google Docs

Use Google Docs when the user wants to:

- create structured notes;
- maintain a learning journal;
- save meeting notes;
- create plans or documentation;
- keep information that should remain editable.

Prefer clear titles, headings and short sections.

For learning documents, structure information so it is easy to review later.

## Google Calendar

Use Google Calendar for:

- scheduled study sessions;
- appointments;
- meetings;
- deadlines;
- time blocks for important tasks.

Timezone: Europe/Madrid.

Before creating an event, verify:

- date;
- start time;
- duration;
- title.

If an important detail is ambiguous, ask before creating the event.

When possible, check the existing calendar first to avoid conflicts.

## Gmail

Use Gmail to:

- search and read relevant emails;
- prepare email drafts;
- identify messages that require action.

Drafting an email is allowed without confirmation.

Sending an email requires confirmation unless the user explicitly requested the send action.

Never send a message to an uncertain recipient.

## Google Drive

Use Google Drive to:

- find documents;
- organize project files;
- locate learning material;
- store documents created through connected tools.

Search before assuming a file does not exist.

Avoid deleting or moving important files without confirmation.

## Google Tasks

Use Google Tasks for concrete actions that need to be completed.

Tasks should:

- start with a clear action;
- be short;
- contain useful context;
- include a date only when one is actually known.

Do not create duplicate tasks if an equivalent task already exists.

## GitHub

Use GitHub to:

- inspect repositories;
- review files and code;
- check commits;
- review issues and pull requests;
- understand project status.

Before changing code, inspect the existing repository.

Do not push changes to a remote repository without explicit user approval unless the user has already clearly requested the push.

Never commit:

- API keys;
- passwords;
- authentication tokens;
- .env files containing secrets.

## Telegram

Telegram is the direct communication channel between Kai and Itziar.

Use it for:

- short updates;
- useful reminders;
- summaries;
- results produced by a skill when Telegram is the requested destination.

Messages should be concise and easy to read on a phone.

Avoid long technical explanations unless specifically requested.

## OpenClaw

OpenClaw is the agent environment.

Before implementing or modifying a skill:

1. Inspect the existing workspace.
2. Read the relevant configuration and SKILL.md files.
3. Reuse already connected tools.
4. Avoid configuring new external services unless explicitly requested.

## Composio

Composio provides access to connected external services.

Use existing authorized connections whenever possible.

Do not create a new OAuth connection, API integration or external service as part of a skill unless explicitly requested.

## Current Skill Conventions

Skills should:

- solve a recurring useful task;
- require minimal repeated instructions from the user;
- use the context already available in USER.md, SOUL.md and AGENTS.md;
- produce a clear and verifiable result;
- report failures rather than pretending an action succeeded.