# 04. Waiting with a stopwatch

Built in slice 4. Until then this page holds the job.

## The job

A request goes to a service that sometimes answers late or never. The caller gives it a time limit, tries again a few times, and may give up altogether while an attempt is still out. The service's answer, when it finally comes, must land somewhere harmless.

The question: how do a time limit and a cancel look when there is no thread to interrupt?
