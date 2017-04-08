FactoryGirl.define do
  factory :topic do
    association :user
    node_id 1
    title 'test'
    body '<p>test</p>'

    factory :text_body do
      body 'test'
    end

    factory :valid_html_body do
      body '<p>test</p>'
    end

    factory :invalid_html_body do
      body '<script>alert("test");</script>'
    end

  end
end
