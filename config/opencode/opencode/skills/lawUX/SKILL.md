---
name: lawUX
description: Laws of UX — transform 30 UX laws (Jakob, Hick, Fitts, Miller, etc.) into actionable product-building heuristics.
---

# lawUX — Product-Building Agent Skill

## Purpose
Transform Laws of UX principles into actionable product-building intelligence for an AI agent that designs, reviews, implements, and improves software products.

## Operating Rules
- Treat UX laws as heuristics, not rigid rules.
- Diagnose the user problem before proposing solutions.
- Distinguish:
  - Source-derived rule
  - Derived application
  - General engineering practice

## Product Decision Protocol

### 1. Understand Context
Identify:
- user goal
- business goal
- task
- expectations
- constraints
- existing patterns

### 2. Identify Applicable Principles
Select only principles relevant to the decision.

### 3. Diagnose
Determine:
- what is difficult
- why it is difficult
- which principle explains the issue
- competing principles

### 4. Generate Solutions
Prefer solutions that:
- solve underlying problems
- reduce unnecessary cognitive effort
- preserve useful conventions
- fit context

### 5. Resolve Conflicts
Identify trade-offs instead of forcing one principle.

### 6. Implement
Translate principles into:
- navigation
- information architecture
- interaction patterns
- states
- feedback
- forms
- onboarding
- responsive behavior

### 7. Self Review
Check:
- unnecessary complexity
- inconsistent patterns
- unintended side effects
- violated principles

### 8. Validate
Use:
- usability testing
- observation
- task success
- behavioral evidence

---

# Jakob's Law

## Principle
Users transfer expectations from familiar products to new products that appear similar.

## Agent Behavior
Before creating novel interactions:
1. Identify existing user mental models.
2. Reuse familiar patterns when appropriate.
3. Introduce novelty only when it improves the core experience.

## Detect
Look for:
- users searching for expected controls
- confusion about navigation
- unexpected workflow behavior
- redesign backlash

## Avoid
Do not:
- redesign familiar patterns only for uniqueness
- remove conventions without reason
- assume users will learn automatically

## Exceptions
Break conventions when:
- the new model provides meaningful improvement
- users have motivation and support to learn
- existing patterns prevent solving the problem

## Review Format
Problem → Evidence → Principle → Impact → Recommendation → Implementation

---

# Aesthetic–Usability Effect

## Principle
Users often perceive aesthetically pleasing designs as more usable.

## Agent Behavior
Evaluate both:
- perceived usability
- actual usability

## Detect
Look for:
- positive visual feedback hiding task problems
- stakeholders prioritizing appearance over success
- usability tests influenced by polish

## Avoid
Do not:
- equate beauty with usability
- replace behavioral testing with opinions

## Validation
Observe:
- task completion
- errors
- hesitation
- actual user behavior

---

# Product Review Mode

When auditing an interface:

1. Inspect systematically.
2. Identify applicable principles.
3. Find concrete evidence.
4. Explain impact.
5. Recommend implementation changes.
6. Separate usability issues from aesthetic preference.
