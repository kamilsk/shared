> # shared:research-go:errors
>
> Research result.

## Error wrappers

### Candidates

- [github.com/juju/errors](https://github.com/juju/errors/)
- [github.com/pkg/errors](https://github.com/pkg/errors/)

### Summary

| Criterion        | juju/errors | pkg/errors   |
|:-----------------|:-----------:|:------------:|
| Liveliness       | ✅          | ✅           |
| No external deps | ✅          | ✅           |
| Simplicity       | ❎          | ✅           |
| Replace          |             |              |
| - `errors`       | ✅          | ✅           |
| - `fmt.Errorf`   | ✅          | ✅           |
| Only context     | ❎          | ✅           |
| Only stack trace | ❎          | ✅           |
| Combination      | ✅          | ✅           |
| Underlying error | ✅          | ✅           |
| License          | LGPLv3      | BSD-2-Clause |

### Recommendation

[github.com/juju/errors](https://github.com/juju/errors/) is more complex and rich,
but [github.com/pkg/errors](https://github.com/pkg/errors/) is my preferred choice.

## Panic handlers

### Candidates

- [github.com/oxequa/grace](https://github.com/oxequa/grace/)

### Summary

| Criterion        | oxequa/grace |
|:-----------------|:------------:|
| Liveliness       | ✅           |
| No external deps | ✅           |
| Simplicity       | ✅           |
| Underlying error | ❎           |
| License          |              |

### Recommendation

...
