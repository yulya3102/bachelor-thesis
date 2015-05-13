# vim: set filetype=python :

def configure(conf):
    conf.load('tex')
    conf.load('pandoc', tooldir='.')

def build(bld):
    sources = """
        Introduction.pd
        ch_First/chapter.latex
        ch_Development/chapter.latex
        ch_Development/sec_Instructions.pd
        ch_Development/Instructions.latex
        ch_Development/sec_SSAProblems.pd
        ch_Development/sec_Diffs.pd
        ch_Development/sec_Meta.pd
        ch_Development/sec_Conclusion.latex
        Conclusion.pd
        Licensing.pd
    """
    bld(features='pandoc-merge', source=sources + ' bib.bib', target='main.latex',
            disabled_exts='fancy_lists', 
            flags='-R -S --latex-engine=xelatex --listings --chapters',
            linkflags='--toc --chapters -R', template='template.latex')

    # Outputs main.pdf
    bld(features='tex', type='xelatex', source='main.latex', prompt=True)
    bld.add_manual_dependency(bld.bldnode.find_or_declare('main.pdf'),
                              bld.srcnode.find_node('utf8gost705u.bst'))
