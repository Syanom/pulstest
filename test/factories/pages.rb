FactoryBot.define do
  factory :page do
    name { 'page_name' }
    content_raw { "*[строка]*\n\\\\[строка]\\\\\n((name1/name2/name3 [строка]))" }
    content { 'MyText' }
    header { 'page_header' }
  end
end
