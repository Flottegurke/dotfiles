# secrets/
This directory contains encrypted secrets managed with [agenix](https://github.com/ryantm/agenix) and the configuration used to determine their recipients.

## Overview
A host consumes a secret by declaring `age.secrets.<name>.file` pointing at one of the encrypted `.age` files.
The secret is decrypted at activation time and made available at `/run/agenix/<name>`

A host's SSH public key is used as its age recipient.
The recipient lists are generated from the metadata block defined in `../hosts/<name>/default.nix`.

## Files
| File                               | Purpose                                                    |
|------------------------------------|------------------------------------------------------------|
| [`secrets.nix`](./secrets.nix)     | Declares which groups of machines can decrypt each secret. |
| [`keys.nix`](./keys.nix)           | Builds recipient lists from host metadata and SSH keys.    |
| [`keys-data.nix`](./keys-data.nix) | Maps host names to their SSH public keys.                  |
| `*.age`                            | The actual encrypted secrets.                              |

### Recipient groups
[`keys.nix`](./keys.nix) exposes several recipient groups:

| Group                   | Recipients                                                                               |
|-------------------------|------------------------------------------------------------------------------------------|
| `keys.allMachines`      | All hosts with a configured SSH key                                                      |
| `keys.allDesktops`      | All hosts marked with `isDesktop = true` (Desktop machines)                              |
| `keys.allWorkMachines`  | All hosts marked with `isWork = true` (Work machines)                                    |
| `keys.allAdminMachines` | All hosts marked with `isAdmin = true` (Machines capable of ssh-ing into other machines) |

## Adding a new secret
1. Add the secret to [`secrets.nix`](./secrets.nix) and select the appropriate recipient group:
   ```nix
   "my-secret.age".publicKeys = keys.allMachines;
   ```
2. Create the secret (and paste the clear-test contents):
   ```shell
   agenix -e my-secret.age
   ```
3. Reference it from a host or module:
   ```nix
   age.secrets.my-secret.file = ../../secrets/my-secret.age;
   ```