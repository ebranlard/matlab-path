function filename=figure2filename(title)
  filename=regexprep(title,'[%|:;.\[ \]\\=^*_/]','');
end
