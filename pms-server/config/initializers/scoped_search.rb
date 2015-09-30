module ScopedSearch::QueryLanguage::Tokenizer
  def tokenize_keyword(&block)
    keyword = current_char
    keyword << next_char while /[^=~<>\&\|\)\(,]/ =~ peek_char
    KEYWORDS.has_key?(keyword.downcase) ? yield(KEYWORDS[keyword.downcase]) : yield(keyword)
  end
end