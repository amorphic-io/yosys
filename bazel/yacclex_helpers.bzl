"""Port of the original rules to bzlmod bison and lex."""

def genlex(name, src, out, prefix = "yy"):
    native.genrule(
        name = name,
        srcs = [src],
        outs = [out],
        cmd = "M4=$(M4) $(FLEX) -P {} --outfile=$@ $<".format(prefix),
        toolchains = [
            "@rules_flex//flex:current_flex_toolchain",
            "@rules_m4//m4:current_m4_toolchain",
        ],
    )


def genyacc(name, src, header_out, source_out, prefix = None, extra_outs = []):
    extra_arg = ""
    if prefix:
        extra_arg = "--name-prefix={}".format(prefix)
    native.genrule(
        name = name,
        srcs = [src],
        outs = [
            header_out,
            source_out,
        ] + extra_outs,
        cmd = """
        M4=$(M4) $(BISON) \
          --defines=$(@D)/{} \
          --output-file=$(@D)/{} {} $<
        """.format(header_out, source_out, extra_arg),
        toolchains = [
            "@rules_bison//bison:current_bison_toolchain",
            "@rules_m4//m4:current_m4_toolchain",
        ],
    )
