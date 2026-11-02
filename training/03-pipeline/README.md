# 03. The assembly line

Built in slice 3. Until then this page holds the job.

## The job

Three stages in a row: parse, enrich, write. Each stage hands its output to the next through a small tray that can hold only so many items. When the tray is full the stage before it must wait. When the tray is empty the stage after it must wait. This is backpressure, and every pipeline that does not lose data has it.

The question: what does a stage hold while it waits for the tray to fill, or to drain?
