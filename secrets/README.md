# secrets/
This directory houses encrypted secrets, managed via [agenix](https://github.com/ryantm/agenix).

## Overview
A host consumes a secret by declaring `age.secrets.<name>.file` pointing at one of these files, which decrypts it at activation time to `/run/agenix/<name>`, using that host's own SSH key.

User account secrets follow the naming convention `users-<username>-password.age`, auto-wired by [`nixos/users/default.nix`](../nixos/users/default.nix) for any enabled user.

## Files

| File | Purpose |
|---|---|
| [`secrets.nix`](./secrets.nix) | Declares which public keys (recipients) can decrypt each secret. |
| `*.age` | The actual encrypted secrets - decryptable only by their declared recipients. |

## Adding a new secret
> [!NOTE]
> To add a new user-password, firstly run:
> ```shell
> mkpasswd -m yescrypt
> ```
> and copy the hash for the next step.

1. Add an entry to `secrets.nix`, listing which keys should be able to decrypt it.
2. Create/edit the encrypted content, with:
   ```shell
   agenix -e <name>.age
   ```
3. Reference it from a host or module via `age.secrets.<name>.file = ../../secrets/<name>.age;`.

## Adding a new recipient (e.g. a newly installed host)
Add the host's SSH public key to (`secrets.nix`)[./secrets.nix], then re-encrypt existing secrets for the updated recipient list with:
```shell
agenix -r
```
