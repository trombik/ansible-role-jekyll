## `trombik.template_role`

A template for `ansible` role.

### Features

* A ready-to-test role. Tests includes: `yamlint`for YAML files, `rubocop` for
  `ruby` files, `serverspec` for unit tests, and `molecule` for integration tests.
* Supports CI in `travis CI`
* Supported Virtualisations: `virtualbox` for `serverspec` and `molecule`,
  `virtualbox` and `docker` for `molecule`.`
* Supported OS platforms inlcude: FreeBSD, OpenBSD, Ubuntu, and CentOS

## Requirements

TBW

## LICENSE

```
Copyright (c) 2019 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```