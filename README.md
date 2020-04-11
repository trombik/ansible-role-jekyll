# `trombik.jekyll`

[![Build Status](https://travis-ci.com/trombik/trombik.jekyll.svg?branch=master)](https://travis-ci.com/trombik/trombik.jekyll)

`ansible` role to manage `jekyll` sites. This role does:

* checkout or update repositories
* install required gems using `bundler`
* rebuild sites

# Requirements

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `jekyll_user` | User name of `jekyll` site owner | `""` |
| `jekyll_repositories` | See below | `[]` |
| `jekyll_extra_packages` | List of extra packages to install | `[]` |

## `jekyll_repositories`

This is a list of dict. Each element of the list describes a site.

| Key | Description | Mandatory? |
|-----|-------------|------------|
| `name` | Name of the site | No |
| `module` | `ansible` module name to checkout the site (currently, only `git` is supported) | Yes |
| `config` | a dict, passed to  the `ansible` module | Yes |
| `bundler` | a dict of `bundler` module arguments | No |
| `state` | Either `present` or `absent`, default is `present` | No |

In addition, `config` key must have the following keys:

| Key    | Description                |
|--------|----------------------------|
| `dest` | The path to the repository |

```
jekyll_repositories:
  - name: demo
    module: git
    config:
      repo: https://github.com/trombik/startbootstrap-coming-soon.git
      dest: /home/vagrant/demo
      version: "{{ os_branch[ansible_os_family] }}"
    bundler:
      deployment_mode: yes
      user_install: yes
```

## Debian

| Variable | Default |
|----------|---------|

## FreeBSD

| Variable | Default |
|----------|---------|

## OpenBSD

| Variable | Default |
|----------|---------|

## RedHat

| Variable | Default |
|----------|---------|

# Dependencies

# Example Playbook

```yaml
---
- hosts: localhost
  roles:
    - role: trombik.git
    - role: trombik.language_ruby
    - role: trombik.bundler
    - role: trombik.redhat_repo
      when: ansible_os_family == 'RedHat'
    - role: ansible-role-jekyll
  pre_tasks:
    - name: Dump all hostvars
      debug:
        var: hostvars[inventory_hostname]
  post_tasks:
    - name: List all services (systemd)
      # workaround ansible-lint: [303] service used in place of service module
      shell: "echo; systemctl list-units --type service"
      changed_when: false
      when:
        # in docker, init is not systemd
        - ansible_virtualization_type != 'docker'
        - ansible_os_family == 'RedHat' or ansible_os_family == 'Debian'
    - name: list all services (FreeBSD service)
      # workaround ansible-lint: [303] service used in place of service module
      shell: "echo; service -l"
      changed_when: false
      when:
        - ansible_os_family == 'FreeBSD'
  vars:
    os_language_ruby_package:
      FreeBSD: "{{ __language_ruby_package }}"
      # XXX ruby26 for OpenBSD 6.5 does not have bundler
      OpenBSD: "{% if ansible_distribution_version is version_compare('6.6', '>=') %}ruby%2.6{% else %}ruby%2.5{% endif %}"
      Debian: "{{ __language_ruby_package }}"
      RedHat: "{{ __language_ruby_package }}"
    language_ruby_package: "{{ os_language_ruby_package[ansible_os_family] }}"

    os_bundler_package:
      FreeBSD: "{{ __bundler_package }}"
      OpenBSD: "ruby{{ language_ruby_version.short }}-bundler"
      Debian: "{{ __bundler_package }}"
      RedHat: "{{ __bundler_package }}"
    bundler_package: "{{ os_bundler_package[ansible_os_family] }}"

    os_branch:
      FreeBSD: demo
      OpenBSD: demo_bundler_1_2
      Debian: demo_bundler_1_2
      RedHat: demo_bundler_1_2

    os_jekyll_extra_packages:
      FreeBSD: []
      OpenBSD: []
      Debian:
        - ruby-dev
      RedHat:
        - gcc-c++
        - ruby-devel
    jekyll_extra_packages: "{{ os_jekyll_extra_packages[ansible_os_family] }}"
    jekyll_user: vagrant
    project_jekyll_bundler_bin:
      OpenBSD: "bundle{{ language_ruby_version.short }}"
      Debian: "bundle"
      FreeBSD: "bundle"
      RedHat: "bundle"
    jekyll_repositories:
      - name: demo
        module: git
        config:
          repo: https://github.com/trombik/startbootstrap-coming-soon.git
          dest: /home/vagrant/demo
          version: "{{ os_branch[ansible_os_family] }}"
        bundler:
          deployment_mode: no
          user_install: yes
          extra_args: ""
          executable: "{{ project_jekyll_bundler_bin[ansible_os_family] }}"
      - name: removeme
        config:
          dest: /home/vagrant/removeme
        state: absent

    redhat_repo_extra_packages:
      - epel-release
    redhat_repo:
      epel:
        mirrorlist: "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-{{ ansible_distribution_major_version }}&arch={{ ansible_architecture }}"
        gpgcheck: yes
        enabled: yes
```

# License

```
Copyright (c) 2020 Tomoyuki Sakurai <y@trombik.org>

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

# Author Information

Tomoyuki Sakurai <y@trombik.org>
