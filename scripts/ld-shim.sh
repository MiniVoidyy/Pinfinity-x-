#!/bin/bash
# ld wrapper: ld.lld errors on empty relocatable link (no .o inputs).
# GNU ld handles this fine; shim emulates for lld by creating empty .o.
real_ld=/home/mini/pinfinity-src/prebuilts/clang/host/linux-x86/clang-r450784d/bin/ld.lld
input_found=false
for arg in "$@"; do
    case "$arg" in
        *.o|*.a|*.lo) input_found=true; break ;;
    esac
done
if [ "$input_found" = false ]; then
    needs_r=false
    for arg in "$@"; do
        [ "$arg" = "-r" ] && needs_r=true
    done
    if [ "$needs_r" = true ]; then
        out_file=""
        args=("$@")
        for ((i=0; i<${#args[@]}; i++)); do
            if [ "${args[$i]}" = "-o" ]; then
                out_file="${args[$((i+1))]}"
                break
            fi
        done
        if [ -n "$out_file" ]; then
            # Create minimal valid ELF relocatable empty object
            python3 -c "
import struct, sys
# Minimal ELF header for aarch64 relocatable empty object
e_ident = b'\x7fELF' + bytes([2,1,1,0]) + b'\x0'*8  # 64-bit LE
e_type = struct.pack('<H', 1)   # ET_REL
e_machine = struct.pack('<H', 183)  # EM_AARCH64
e_version = struct.pack('<I', 1)
# empty ELF with no sections
hdr = e_ident + e_type + e_machine + e_version
hdr += b'\x0'*16  # e_entry, e_phoff
hdr += struct.pack('<Q', 64)  # e_shoff (section header at 64)
hdr += struct.pack('<I', 0)   # e_flags
hdr += struct.pack('<H', 64)  # e_ehsize
hdr += struct.pack('<H', 0)   # e_phentsize
hdr += struct.pack('<H', 0)   # e_phnum
hdr += struct.pack('<H', 64)  # e_shentsize
hdr += struct.pack('<H', 4)   # e_shnum (1 section header)
hdr += struct.pack('<H', 0)   # e_shstrndx
# section header: SHT_NULL
shdr = b'\x0'*64
open(sys.argv[1], 'wb').write(hdr + shdr)
" "$out_file"
            exit 0
        fi
    fi
fi
exec "$real_ld" "$@"
