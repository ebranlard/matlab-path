function filename=title2filename(title)
  title=strrep(title,'@','');
  filename=regexprep(title,'[%|:;.\[ \]\\=^*_/]','');
end
