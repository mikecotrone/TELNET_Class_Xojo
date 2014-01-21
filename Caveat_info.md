Caveats Found and Fixed in v1.0(4) and below:

- SO Output Queuing structure was flawed when I added support for New Environment and X Display Location
          - I redesigned and reimplemented this SO outbound queuing structure 

- Removed various unused variables ;)

- Changed how I was emptying my Input and Output queues

- Fixed the IAC RegEx pattern to match 100% correctly now
