# coding: utf-8

Groonga::Schema.define do |schema|
  schema.create_table('ContentBody',
    type: :hash
  ) do |t|
    t.text('body')
  end

  schema.create_table('ReposCache',
    type: :patricia_trie,
    key_type: 'ShortText',
    default_tokenizer: 'TokenBigram',
    key_normalize: true
   ) do |t|
     t.index('ContentBody.body')
   end
end
