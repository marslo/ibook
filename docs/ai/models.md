<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [rate_limits](#rate_limits)
- [model_limits](#model_limits)
- [models](#models)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## rate_limits

> [!NOTE|label:references:]
> - [rates limits](https://platform.openai.com/settings/organization/limits)

<!--sec data-title="curl API call" data-id="section0" data-show=true data-collapse=true ces-->
```bash
$ curl -s https://api.openai.com/dashboard/rate_limits \
       -H "Authorization: Bearer $OPENAI_AUTHORIZE_KEY" \
       -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)' \
       -H 'Accept: application/json' \
       -H 'Content-Type: application/json' |
  jq -r 'to_entries |
         (["MODEL", "RPM", "TPM", "IMAGES/MIN", "AUDIO_MB/MIN", "RPD", "BATCH_TOKENS"]),
         (.[] | [
           .key,
           (.value.max_requests_per_1_minute        // "-" | if . == "-" then . else (. | tostring + " RPM") end),
           (.value.max_tokens_per_1_minute          // "-" | if . == "-" then . else (. | tostring + " TPM") end),
           (.value.max_images_per_1_minute          // "-" | if . == "-" then . else (. | tostring + " IPM") end),
           (.value.max_audio_megabytes_per_1_minute // "-" | if . == "-" then . else (. | tostring + " MB/min") end),
           (.value.max_requests_per_1_day           // "-" | if . == "-" then . else (. | tostring + " req/day") end),
           (.value.batch_1_day_max_input_tokens     // "-" | if . == "-" then . else (. | tostring + " tokens") end)
         ]) | @tsv' |
  column -t -s $'\t'
```
<!--endsec-->

| MODEL                                   | RPM        | TPM              | IMAGES/MIN       | AUDIO_MB/MIN | RPD                  | BATCH_TOKENS     |
|-----------------------------------------|------------|------------------|------------------|--------------|----------------------|------------------|
| babbage-002                             | 3000.0 RPM | 250000.0 TPM     | 10.0 IPM         | -            | -                    | -                |
| dall-e-2                                | 500.0 RPM  | 2147483647.0 TPM | 5.0 IPM          | -            | -                    | -                |
| gpt-4o-mini-2024-07-18                  | 500.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | 10000.0 req/day      | 2000000.0 tokens |
| gpt-4o-mini                             | 500.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | 10000.0 req/day      | 2000000.0 tokens |
| gpt-4o-2024-11-20                       | 500.0 RPM  | 30000.0 TPM      | 50000.0 IPM      | -            | -                    | 90000.0 tokens   |
| gpt-4o-mini-search-preview              | 100.0 RPM  | 6000.0 TPM       | 0.0 IPM          | -            | -                    | 0.0 tokens       |
| gpt-4o-mini-search-preview-2025-03-11   | 100.0 RPM  | 6000.0 TPM       | 0.0 IPM          | -            | -                    | 0.0 tokens       |
| davinci-002                             | 3000.0 RPM | 250000.0 TPM     | 10.0 IPM         | -            | -                    | -                |
| gpt-4-turbo                             | 500.0 RPM  | 30000.0 TPM      | 500.0 IPM        | -            | 2147483647.0 req/day | 90000.0 tokens   |
| o3-mini-2025-01-31                      | 500.0 RPM  | 200000.0 TPM     | -                | -            | -                    | 2000000.0 tokens |
| gpt-4.1                                 | 500.0 RPM  | 30000.0 TPM      | 50000.0 IPM      | -            | -                    | 900000.0 tokens  |
| gpt-3.5-turbo-instruct-0914             | 3500.0 RPM | 90000.0 TPM      | 2147483647.0 IPM | -            | -                    | 200000.0 tokens  |
| gpt-4.1-mini-2025-04-14                 | 500.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | -                    | 2000000.0 tokens |
| gpt-4.1-mini                            | 500.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | -                    | 2000000.0 tokens |
| gpt-3.5-turbo-instruct                  | 3500.0 RPM | 90000.0 TPM      | 2147483647.0 IPM | -            | -                    | 200000.0 tokens  |
| gpt-4o-mini-tts                         | 500.0 RPM  | 50000.0 TPM      | 0.0 IPM          | -            | -                    | 0.0 tokens       |
| gpt-4.1-nano-2025-04-14                 | 500.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | -                    | 2000000.0 tokens |
| gpt-4-turbo-2024-04-09                  | 500.0 RPM  | 30000.0 TPM      | 500.0 IPM        | -            | 2147483647.0 req/day | 90000.0 tokens   |
| gpt-image-1                             | -          | 100000.0 TPM     | 5.0 IPM          | -            | -                    | -                |
| o4-mini-2025-04-16                      | 500.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | -                    | 2000000.0 tokens |
| gpt-4                                   | 500.0 RPM  | 10000.0 TPM      | -                | -            | 10000.0 req/day      | 100000.0 tokens  |
| o1-2024-12-17                           | 500.0 RPM  | 30000.0 TPM      | -                | -            | -                    | 90000.0 tokens   |
| o3-mini                                 | 500.0 RPM  | 200000.0 TPM     | -                | -            | -                    | 2000000.0 tokens |
| gpt-4.1-2025-04-14                      | 500.0 RPM  | 30000.0 TPM      | 50000.0 IPM      | -            | -                    | 900000.0 tokens  |
| gpt-4o-audio-preview                    | 500.0 RPM  | 30000.0 TPM      | 50000.0 IPM      | -            | -                    | 90000.0 tokens   |
| gpt-4o-2024-05-13                       | 500.0 RPM  | 30000.0 TPM      | 50000.0 IPM      | -            | -                    | 90000.0 tokens   |
| gpt-4o-search-preview-2025-03-11        | 100.0 RPM  | 6000.0 TPM       | 0.0 IPM          | -            | -                    | 0.0 tokens       |
| gpt-4o-search-preview                   | 100.0 RPM  | 6000.0 TPM       | 0.0 IPM          | -            | -                    | 0.0 tokens       |
| gpt-4o-mini-transcribe                  | 500.0 RPM  | 50000.0 TPM      | 0.0 IPM          | -            | -                    | 0.0 tokens       |
| gpt-3.5-turbo-16k                       | 500.0 RPM  | 200000.0 TPM     | -                | -            | 10000.0 req/day      | 2000000.0 tokens |
| o1-mini                                 | 500.0 RPM  | 200000.0 TPM     | -                | -            | -                    | 2000000.0 tokens |
| o1-mini-2024-09-12                      | 500.0 RPM  | 200000.0 TPM     | -                | -            | -                    | 2000000.0 tokens |
| gpt-4.1-nano                            | 500.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | -                    | 2000000.0 tokens |
| gpt-4.5-preview                         | 1000.0 RPM | 125000.0 TPM     | 50000.0 IPM      | -            | -                    | 50000.0 tokens   |
| gpt-4.5-preview-2025-02-27              | 1000.0 RPM | 125000.0 TPM     | 50000.0 IPM      | -            | -                    | 50000.0 tokens   |
| gpt-4o-realtime-preview-2024-10-01      | 200.0 RPM  | 40000.0 TPM      | -                | -            | 1000.0 req/day       | -                |
| gpt-3.5-turbo                           | 500.0 RPM  | 200000.0 TPM     | -                | -            | 10000.0 req/day      | 2000000.0 tokens |
| chatgpt-4o-latest                       | 200.0 RPM  | 500000.0 TPM     | -                | -            | -                    | -                |
| o4-mini                                 | 500.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | -                    | 2000000.0 tokens |
| gpt-4o-audio-preview-2025-06-03         | 3000.0 RPM | 250000.0 TPM     | 10.0 IPM         | -            | -                    | -                |
| gpt-4o-audio-preview-2024-12-17         | 500.0 RPM  | 30000.0 TPM      | 50000.0 IPM      | -            | -                    | 90000.0 tokens   |
| o1-pro-2025-03-19                       | 500.0 RPM  | 30000.0 TPM      | -                | -            | -                    | 90000.0 tokens   |
| gpt-4o-mini-audio-preview-2024-12-17    | 500.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | 10000.0 req/day      | 2000000.0 tokens |
| gpt-3.5-turbo-1106                      | 500.0 RPM  | 200000.0 TPM     | -                | -            | 10000.0 req/day      | 2000000.0 tokens |
| o1                                      | 500.0 RPM  | 30000.0 TPM      | -                | -            | -                    | 90000.0 tokens   |
| gpt-4o-audio-preview-2024-10-01         | 500.0 RPM  | 30000.0 TPM      | 50000.0 IPM      | -            | -                    | 90000.0 tokens   |
| o1-pro                                  | 500.0 RPM  | 30000.0 TPM      | -                | -            | -                    | 90000.0 tokens   |
| tts-1                                   | 500.0 RPM  | 2147483647.0 TPM | -                | -            | -                    | -                |
| gpt-3.5-turbo-0125                      | 500.0 RPM  | 200000.0 TPM     | -                | -            | 10000.0 req/day      | 2000000.0 tokens |
| codex-mini-latest                       | 500.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | -                    | 2000000.0 tokens |
| gpt-4o-mini-realtime-preview            | 200.0 RPM  | 40000.0 TPM      | -                | -            | 1000.0 req/day       | -                |
| text-embedding-3-small                  | 3000.0 RPM | 1000000.0 TPM    | -                | -            | -                    | 3000000.0 tokens |
| tts-1-hd                                | 500.0 RPM  | 2147483647.0 TPM | 2147483647.0 IPM | -            | -                    | -                |
| whisper-1                               | 500.0 RPM  | 2147483647.0 TPM | -                | -            | -                    | -                |
| gpt-4-0613                              | 500.0 RPM  | 10000.0 TPM      | -                | -            | 10000.0 req/day      | 100000.0 tokens  |
| tts-1-hd-1106                           | 500.0 RPM  | 2147483647.0 TPM | 2147483647.0 IPM | -            | -                    | -                |
| gpt-4o-realtime-preview-2025-06-03      | 3000.0 RPM | 250000.0 TPM     | 10.0 IPM         | -            | -                    | -                |
| gpt-4-1106-preview                      | 500.0 RPM  | 150000.0 TPM     | -                | -            | 10000.0 req/day      | -                |
| text-embedding-ada-002                  | 3000.0 RPM | 1000000.0 TPM    | -                | -            | -                    | 3000000.0 tokens |
| gpt-4o-realtime-preview-2024-12-17      | 3000.0 RPM | 250000.0 TPM     | 10.0 IPM         | -            | -                    | -                |
| o1-preview-2024-09-12                   | 500.0 RPM  | 30000.0 TPM      | -                | -            | -                    | 90000.0 tokens   |
| gpt-4o-mini-realtime-preview-2024-12-17 | 200.0 RPM  | 40000.0 TPM      | -                | -            | 1000.0 req/day       | -                |
| gpt-4o-mini-audio-preview               | 500.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | 10000.0 req/day      | 2000000.0 tokens |
| text-embedding-3-large                  | 3000.0 RPM | 1000000.0 TPM    | -                | -            | -                    | 3000000.0 tokens |
| gpt-4o                                  | 500.0 RPM  | 30000.0 TPM      | 50000.0 IPM      | -            | -                    | 90000.0 tokens   |
| gpt-4o-2024-08-06                       | 500.0 RPM  | 30000.0 TPM      | 50000.0 IPM      | -            | -                    | 90000.0 tokens   |
| gpt-4-turbo-preview                     | 500.0 RPM  | 30000.0 TPM      | 500.0 IPM        | -            | 2147483647.0 req/day | 90000.0 tokens   |
| gpt-4o-transcribe                       | 500.0 RPM  | 10000.0 TPM      | 0.0 IPM          | -            | -                    | 0.0 tokens       |
| dall-e-3                                | 500.0 RPM  | 2147483647.0 TPM | 5.0 IPM          | -            | -                    | -                |
| gpt-4-0125-preview                      | 500.0 RPM  | 10000.0 TPM      | -                | -            | 10000.0 req/day      | 100000.0 tokens  |
| omni-moderation-2024-09-26              | 500.0 RPM  | 10000.0 TPM      | -                | -            | 10000.0 req/day      | -                |
| gpt-4o-realtime-preview                 | 200.0 RPM  | 40000.0 TPM      | -                | -            | 1000.0 req/day       | -                |
| omni-moderation-latest                  | 500.0 RPM  | 10000.0 TPM      | -                | -            | 10000.0 req/day      | -                |
| o1-preview                              | 500.0 RPM  | 30000.0 TPM      | -                | -            | -                    | 90000.0 tokens   |
| tts-1-1106                              | 500.0 RPM  | 2147483647.0 TPM | -                | -            | -                    | -                |
| text-moderation-latest                  | 1000.0 RPM | 150000.0 TPM     | -                | -            | -                    | -                |
| text-moderation-stable                  | 1000.0 RPM | 150000.0 TPM     | -                | -            | -                    | -                |
| *                                       | 3000.0 RPM | 250000.0 TPM     | 10.0 IPM         | -            | -                    | -                |
| ft:gpt-3.5-turbo-0613                   | 500.0 RPM  | 200000.0 TPM     | -                | -            | 10000.0 req/day      | 2000000.0 tokens |
| ft:gpt-3.5-turbo-1106                   | 500.0 RPM  | 200000.0 TPM     | -                | -            | 10000.0 req/day      | 2000000.0 tokens |
| ft:gpt-3.5-turbo-0125                   | 500.0 RPM  | 200000.0 TPM     | -                | -            | 10000.0 req/day      | 2000000.0 tokens |
| ft:gpt-4-0613                           | 500.0 RPM  | 10000.0 TPM      | -                | -            | 10000.0 req/day      | 100000.0 tokens  |
| ft:gpt-4o-2024-05-13                    | 500.0 RPM  | 30000.0 TPM      | 50000.0 IPM      | -            | -                    | 90000.0 tokens   |
| ft:gpt-4o-mini-2024-07-18               | 500.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | 10000.0 req/day      | 2000000.0 tokens |
| ft:davinci-002                          | 3000.0 RPM | 250000.0 TPM     | 10.0 IPM         | -            | -                    | -                |
| ft:babbage-002                          | 3000.0 RPM | 250000.0 TPM     | 10.0 IPM         | -            | -                    | -                |
| gpt-4.1-long-context                    | 100.0 RPM  | 200000.0 TPM     | 50000.0 IPM      | -            | -                    | 2000000.0 tokens |
| gpt-4.1-mini-long-context               | 200.0 RPM  | 400000.0 TPM     | 50000.0 IPM      | -            | -                    | 4000000.0 tokens |
| gpt-4.1-nano-long-context               | 200.0 RPM  | 400000.0 TPM     | 50000.0 IPM      | -            | -                    | 4000000.0 tokens |

## model_limits

> [!NOTE|label:references:]
> - [model limits](https://platform.openai.com/docs/guides/rate-limits)

<!--sec data-title="api call" data-id="section1" data-show=true data-collapse=true ces-->
```bash

$ curl -s https://api.openai.com/v1/fine_tuning/model_limits \
       -H "Authorization: Bearer $OPENAI_API_KEY" |
  jq -r '["ID", "PENDING JOBS", "MAX PENDING JOBS", "JOBS", "MAX JOBS/DAY"], (.data[] | [.id, .curr_pending_jobs, .max_pending_jobs, .jobs_so_far_today, .max_jobs_per_day]) | @tsv' |
  column -t -s $'\t'
```
<!--endsec-->

| ID                      | PENDING JOBS | MAX PENDING JOBS | JOBS | MAX JOBS/DAY |
|-------------------------|--------------|------------------|------|--------------|
| gpt-3.5-turbo-0125      | 0            | 3                | 0    | 48           |
| gpt-3.5-turbo-1106      | 0            | 3                | 0    | 48           |
| gpt-4.1-2025-04-14      | 0            | 3                | 0    | 8            |
| gpt-4.1-mini-2025-04-14 | 0            | 6                | 0    | 24           |
| gpt-4.1-nano-2025-04-14 | 0            | 6                | 0    | 24           |
| gpt-4o-2024-08-06       | 0            | 3                | 0    | 8            |
| gpt-4o-mini-2024-07-18  | 0            | 5                | 0    | 24           |
| o4-mini-2025-04-16      | 0            | 2                | 0    | 4            |

## models

> [!NOTE|label:references:]
> - [models](https://platform.openai.com/docs/api-reference/models/list)

<!--sec data-title="api call" data-id="section2" data-show=true data-collapse=true ces-->
```bash
$ curl -s https://api.openai.com/v1/models \
       -H "Authorization: Bearer $OPENAI_API_KEY" |
  jq -r '["CREATED AT", "MODEL ID"], (.data | sort_by(.created) | reverse[] | [(.created | strftime("%Y-%m-%d %H:%M:%S")), .id]) | @tsv' |
  column -t -s $'\t'
```
<!--endsec-->

| CREATED AT          | MODEL ID                                |
|---------------------|-----------------------------------------|
| 2025-06-02 23:54:58 | gpt-4o-audio-preview-2025-06-03         |
| 2025-06-02 23:43:58 | gpt-4o-realtime-preview-2025-06-03      |
| 2025-05-08 03:00:57 | codex-mini-latest                       |
| 2025-04-24 17:50:30 | gpt-image-1                             |
| 2025-04-10 21:48:27 | gpt-4.1-nano                            |
| 2025-04-10 21:37:05 | gpt-4.1-nano-2025-04-14                 |
| 2025-04-10 20:49:33 | gpt-4.1-mini                            |
| 2025-04-10 20:39:07 | gpt-4.1-mini-2025-04-14                 |
| 2025-04-10 20:22:22 | gpt-4.1                                 |
| 2025-04-10 20:09:06 | gpt-4.1-2025-04-14                      |
| 2025-04-09 19:02:31 | o4-mini                                 |
| 2025-04-08 17:31:46 | o4-mini-2025-04-16                      |
| 2025-03-19 17:05:59 | gpt-4o-mini-tts                         |
| 2025-03-17 22:49:51 | o1-pro                                  |
| 2025-03-17 22:45:04 | o1-pro-2025-03-19                       |
| 2025-03-15 19:56:36 | gpt-4o-mini-transcribe                  |
| 2025-03-15 19:54:23 | gpt-4o-transcribe                       |
| 2025-03-07 23:46:01 | gpt-4o-mini-search-preview              |
| 2025-03-07 23:40:58 | gpt-4o-mini-search-preview-2025-03-11   |
| 2025-03-07 23:05:20 | gpt-4o-search-preview                   |
| 2025-03-07 22:56:10 | gpt-4o-search-preview-2025-03-11        |
| 2025-02-27 02:28:24 | gpt-4.5-preview-2025-02-27              |
| 2025-02-27 02:24:19 | gpt-4.5-preview                         |
| 2025-02-12 03:39:03 | gpt-4o-2024-11-20                       |
| 2025-01-27 20:36:40 | o3-mini-2025-01-31                      |
| 2025-01-17 20:39:43 | o3-mini                                 |
| 2024-12-16 22:17:04 | gpt-4o-mini-audio-preview               |
| 2024-12-16 22:16:20 | gpt-4o-mini-realtime-preview            |
| 2024-12-16 19:03:36 | o1                                      |
| 2024-12-16 05:29:36 | o1-2024-12-17                           |
| 2024-12-13 18:52:00 | gpt-4o-mini-audio-preview-2024-12-17    |
| 2024-12-13 17:56:41 | gpt-4o-mini-realtime-preview-2024-12-17 |
| 2024-12-12 20:10:39 | gpt-4o-audio-preview-2024-12-17         |
| 2024-12-11 19:30:30 | gpt-4o-realtime-preview-2024-12-17      |
| 2024-11-27 19:07:46 | omni-moderation-2024-09-26              |
| 2024-11-15 16:47:45 | omni-moderation-latest                  |
| 2024-09-30 01:33:18 | gpt-4o-realtime-preview                 |
| 2024-09-27 18:07:23 | gpt-4o-audio-preview                    |
| 2024-09-26 22:17:22 | gpt-4o-audio-preview-2024-10-01         |
| 2024-09-23 22:49:26 | gpt-4o-realtime-preview-2024-10-01      |
| 2024-09-06 18:56:48 | o1-mini                                 |
| 2024-09-06 18:56:19 | o1-mini-2024-09-12                      |
| 2024-09-06 18:54:57 | o1-preview                              |
| 2024-09-06 18:54:25 | o1-preview-2024-09-12                   |
| 2024-08-13 02:12:11 | chatgpt-4o-latest                       |
| 2024-08-04 23:38:39 | gpt-4o-2024-08-06                       |
| 2024-07-16 23:32:21 | gpt-4o-mini                             |
| 2024-07-16 23:31:57 | gpt-4o-mini-2024-07-18                  |
| 2024-05-10 19:08:52 | gpt-4o-2024-05-13                       |
| 2024-05-10 18:50:49 | gpt-4o                                  |
| 2024-04-08 18:41:17 | gpt-4-turbo-2024-04-09                  |
| 2024-04-05 23:57:21 | gpt-4-turbo                             |
| 2024-01-23 22:19:18 | gpt-3.5-turbo-0125                      |
| 2024-01-23 19:22:57 | gpt-4-turbo-preview                     |
| 2024-01-23 19:20:12 | gpt-4-0125-preview                      |
| 2024-01-22 19:53:00 | text-embedding-3-large                  |
| 2024-01-22 18:43:17 | text-embedding-3-small                  |
| 2023-11-03 23:18:53 | tts-1-hd-1106                           |
| 2023-11-03 23:14:01 | tts-1-1106                              |
| 2023-11-03 21:13:35 | tts-1-hd                                |
| 2023-11-02 21:15:48 | gpt-3.5-turbo-1106                      |
| 2023-11-02 20:33:26 | gpt-4-1106-preview                      |
| 2023-11-01 00:22:57 | dall-e-2                                |
| 2023-10-31 20:46:29 | dall-e-3                                |
| 2023-09-07 21:34:32 | gpt-3.5-turbo-instruct-0914             |
| 2023-08-24 18:23:47 | gpt-3.5-turbo-instruct                  |
| 2023-08-21 16:16:55 | babbage-002                             |
| 2023-08-21 16:11:41 | davinci-002                             |
| 2023-06-27 16:13:31 | gpt-4                                   |
| 2023-06-12 16:54:56 | gpt-4-0613                              |
| 2023-05-10 22:35:02 | gpt-3.5-turbo-16k                       |
| 2023-04-19 21:49:11 | tts-1                                   |
| 2023-02-28 18:56:42 | gpt-3.5-turbo                           |
| 2023-02-27 21:13:04 | whisper-1                               |
| 2022-12-16 19:01:39 | text-embedding-ada-002                  |
