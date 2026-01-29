#!/usr/bin/env bash
set -euo pipefail

LAUREN_ITER="${LAUREN_ITER:-10}"
LAUREN_DIR="${LAUREN_DIR:-.lauren}"

_iterate() {
  local principles="
    ## Principles

    General design principles:

    - Less is better. Favor minimal solutions that achieve the goal.
    - Design should surprise the user in a positive way.
    - Design should delight the user and be aesthetically pleasing.
    - Design should be timeless, minimal and elegant.
    - User should feel in control at all times.
    - Design should not need explanation or instructions.

    UI design principles:

    - Actions SHOULD be undoable. Prefer undo over confirm.
    - Actions SHOULD be able to be optionally delayed where it makes sense.
    - Actions SHOULD be discoverable. Use affordances, signifiers and feedback.
      In addition, provide visual cues to guide first time users. Gradually, as
      users become more familiar with the UI, these cues can be reduced or
      removed to avoid clutter.
    - Use progressive disclosure to avoid overwhelming users with too much
      information at once.
    - Use consistent visual language and design patterns throughout the UI.
    - Ensure accessibility for all users, including those with disabilities.
    - Provide clear and concise error messages that help users recover from
      mistakes.

    CLI design principles:

    - Follow POSIX conventions where applicable.
    - Allow standard input/output redirection and piping.
    - Allow configuration via command line arguments, environment variables and config
      files.
    - Provide clear and concise help and usage information.
    - Use exit codes to indicate success or failure of commands.
    - Detect terminals and only show colors and interactive prompts when running
      in a terminal.
    - Write messages to standard error, except for command output.
    - Show progress indicators for long running operations.
    - Provide sensible defaults that work out of the box.
    - Allow users to override defaults via configuration.
    - Do not output unnecessary information. Be concise and to the point.

    Code design principles:

    - Always start with data model and data flow before thinking about code.
    - Experiment with code to validate the data model and data flow.
    - Favor simple, straightforward, clear, minimal indirected, well decoupled,
      composable code.
    - Iterate until the data model/flow is nailed down and can accommodate
      current and future requirements.
    - The code you write will be read by many humans and over a long period of
      time. Ensure it is simple, unclever, follows idioms of the language you are
      using, not overly abstracted, not overly optimized, not overly engineered.
    - Document the 'why' behind blocks of code, not the 'what'.

    Testing and verification principles:

    - When writing unit tests, focus on the interface and contract of the code,
      not its implementation.
    - You MUST test/verify your work end-to-end one way or another before
      marking a requirement as 'met'. For e.g., if building a web app, you MUST
      test it in a browser. If you are building a library, you MUST test it in a
      test program that uses the library. If you are building a CLI tool, you MUST
      test it in a terminal.
    - Write tests that are deterministic, isolated, fast, reliable and
      maintainable.
    - Favor high level integration tests over low level unit tests and mockery.
    - Treat tests as first class citizens. They are as important as the code
      itself and must be maintained with the same level of care.
    - Tests are ever evolving and must be updated as the code evolves.
    - Tests must be treated as committable artifacts that are part of the
      codebase.
  "
  local requirements="
    ## Requirements

    The reqirements are defined in $LAUREN_DIR/prd.yaml as an array of objects,
    each with following fields:

    - description: A well defined description of the requirement.
    - steps: A list of steps to verify the requirement.
    - status: One of 'unmet', 'in-progress', 'met', 'invalid'.
  "
  local prologue="
    You are tasked with achieving the high level goal in $LAUREN_DIR/goal.md
    while following the principles laid out below. The goal is NON-NEGOTIABLE - it
    MUST be achieved. You are COMPLETELTY AUTONOMOUS and ON YOUR OWN without
    any human intervention or external help.
  "
  local prompt_one="
    $prologue

    In this session, you will do one iteration towards this goal by:
    - Breaking down the goal into well defined smaller requirements OR refining,
      removing, adding to existing requirements from previous iterations. You must
      ensure that the requirements meet the goal and abide by the principles as
      well as being specific, measurable, achievable, relevant and time-bound.
      Use any learnings available in $LAUREN_DIR/learnings.txt to help you with
      this.
    - Recording your learnings in a concise manner by appending to
      $LAUREN_DIR/learnings.txt as you go to help future iterations.
    - Do NOT implement any code in this session.

    $requirements

    $principles
  "
  local prompt_two="
    $prologue

    In this session, you will do one iteration towards this goal by:
    1. Picking the highest priority requirment that is not yet met or continue
       an in-progress requirement. Pick ONE AND ONLY ONE.
    2. Implementing, testing and verifying that ONE requirement.
       - If implementation/testing surfaces problems with any requirements,
         append your findings to $LAUREN_DIR/learnings.txt and STOP. Do NOT
         proceed to next steps.
       - If successful, update $LAUREN_DIR/prd.yaml to mark the requirement as met.
    3. Refactor existing code as deemed necessary as result of recently
       implemented requirement or learnings from $LAUREN_DIR/learnings.txt from
       previous iterations.
    4. If all requirements are met, create a file $LAUREN_DIR/done to signal goal
       completion.

    Keep these IMPORTANT POINTS in mind:
    - You MUST ONLY work on ONE requirement at a time.
    - You MUST test/verify your work end-to-end before considering a requirement as
      'met'.

    $requirements

    $principles
  "
  codex exec --full-auto --add-dir="$(pwd)/.git" "$prompt_one"
  codex exec --full-auto --add-dir="$(pwd)/.git" "$prompt_two"
}

goal_file="${LAUREN_DIR}/goal.md"
if [ ! -f "$goal_file" ]; then
  echo "Error: $goal_file not found" >&2
  exit 1
fi

for ((i=1; i<=LAUREN_ITER; i++)); do
  if [ -f "${LAUREN_DIR}/done" ]; then
    echo "Goal is achieved. Exiting." >&2
    exit 0
  fi
  echo "--- Iteration $i ---" >&2
  _iterate
done
