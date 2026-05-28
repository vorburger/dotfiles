# NixOS

Status: This is a WIP and currently broken;
see also https://github.com/vorburger/nixfiles
and the older https://github.com/vorburger/LearningLinux/tree/develop/nix/os,
for a clean restart from scratch (which this will be replaced by, when I clean up).

## Usage

To start, just use:

    QEMU_NET_OPTS="hostfwd=tcp::2222-:22" rm -f *.qcow2 && nix run .

Then login to it with:

    ssh -o StrictHostKeyChecking=no -o "UserKnownHostsFile /dev/null" root@localhost -p 2222

This starts the VM through `result/bin/run-nixos-vm` (which you could subsequently also directly start).

This VM has most of the image defined by the flake on `/run` in a `tmpfs` (somehow), and
a (small, initially; ~6 MB!!) `./nixos.qcow2` disk image in the current directory (because it's NOT an "output"),
which is `/dev/vda` that's mounted as `/` in the VM. We `rm` disk images on each start to get a fresh VM.

## Testing

    nix flake check

## More

To build a (big; ~415 MB!) NixOS LiveCD `./result/iso/nixos*.iso` ISO image, use:

    nix build .#nixosConfigurations.nixos-vm.config.system.build.images.iso

This ISO can be booted e.g. in GNOME Boxes by finding its IP under _Preferences_ and `ssh root@192.168.122.36` (or whatever IP it got).
Under Fedora, you may need to `sudo chcon -t virt_content_t result/iso/*.iso` first (for SELinux) to avoid _"Could not open '...iso': Permission denied"_ error.

[See `docs/`](docs/) for more.
