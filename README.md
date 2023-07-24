# ActionFactory
A Simple OOO Factory lib for Ruby (and Rails)

## Usage

### Setup
Create a base factory class
```ruby
class ApplicationFactory < ActionFactory::Base
end
```

If you're using `ActiveRecord`, add the `association` helpers
```ruby
class ApplicationFactory < ActionFactory::Base
  include ActionFactory::ActiveRecord
end
```

### Creating your first factory
```ruby
class UserFactory < ApplicationFactory
  attribute(:name) { "Hank Green" }
  sequence(:email) { |i| "hgreen#{i}@example.com" }

  trait(:activated) do
    instance.activate!
  end
end
```

### Callbacks
`ActionFactory::Base` uses `ActiveModel::Callbacks` to add the following lifecycle events:
```
after_initialize
before_assign_attributes
around_assign_attributes
after_assign_attributes
before_create
around_create
after_create
```

For example
```ruby
class MyModelFactory < ApplicationFactory
  after_initialize :do_the_thing

  private

  def do_the_thing
    instance.some_attribute = true if attributes[:some_attribute].blank?
  end
end
```

### Including helpers
You can use `ActionFactory::Helpers` to call `create(:my_factory_name)` and `build(:my_factory_name)`.
Here's an example for setting it up with RSpec:
```ruby
RSpec.configure do |config|
  config.include ActionFactory::Helpers
end
```

## Installation
Via bundler:
```bash
bundle add action_factory
```

Or install it yourself as:
```bash
$ gem install action_factory
```

## Contributing
Contributions welcome

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
