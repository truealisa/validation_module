### Validation module
#### /Gotoinc test task/

Module realized in `validation.rb` can be included into class to add validation functionality.

1) Class method `validate` takes two arguments: attribute name and options with validation types and rules.
These are possible validation types:

- presence - requires an attribute to be neither nil nor an empty string. Usage example:
```
validate :name, presence: true
```

- format - requires an attribute to match the passed regular expression. Usage example:
```
validate :number, format: /A-Z{0,3}/
```

- type - requires an attribute to be an instance of the passed class. Usage example:
```
validate :owner, type: User
```

2) Instance method `validate!` runs all checks and validations, that added to a class via the class method `validate`. In case of any mismatch it raises an exception with a message that says what exact validation failed.

3) Instance method `valid?` returns `true` if all validations pass and `false` if there is any validation fail.

**`User` and `Profile` classes demonstrate usage cases.**

Require classes:
```
irb(main):001:0> require_relative 'user.rb'
=> true
irb(main):002:0> require_relative 'profile.rb'
=> true
```

Valid user case:
```
irb(main):003:0> valid_user = User.new('John', '1234567890')
=> #<User:0x000055fcb3518190 @name="John", @phone_number="1234567890">

irb(main):004:0> valid_user.validate!
=> #<User:0x000055fcb3518190 @name="John", @phone_number="1234567890">

irb(main):005:0> valid_user.valid?
=> true
```

User with invalid name:
```
irb(main):006:0> invalid_name_user = User.new('J', '1234567890')
=> #<User:0x000055fcb353fe48 @name="J", @phone_number="1234567890">

irb(main):007:0> invalid_name_user.valid?
=> false

irb(main):008:0> invalid_name_user.validate!
Traceback (most recent call last):
       10: from /home/truealisa/.rbenv/versions/2.6.3/bin/irb:23:in `<main>'
        9: from /home/truealisa/.rbenv/versions/2.6.3/bin/irb:23:in `load'
        8: from /home/truealisa/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        7: from (irb):7
        6: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:18:in `validate!'
        5: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:18:in `each_pair'
        4: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:19:in `block in validate!'
        3: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:19:in `each_pair'
        2: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:24:in `block (2 levels) in validate!'
        1: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:59:in `validate_format'
Validation::ValidationError (Validation failed, `name` must match Regexp: /\w{3,24}/)
```

User with invalid phone:
```
irb(main):008:0> invalid_phone_user = User.new('John', '123456esf0')
=> #<User:0x000055fcb355ba08 @name="John", @phone_number="123456esf0">

irb(main):009:0> invalid_phone_user.valid?
=> false

irb(main):010:0> invalid_phone_user.validate!
Traceback (most recent call last):
       10: from /home/truealisa/.rbenv/versions/2.6.3/bin/irb:23:in `<main>'
        9: from /home/truealisa/.rbenv/versions/2.6.3/bin/irb:23:in `load'
        8: from /home/truealisa/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        7: from (irb):9
        6: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:18:in `validate!'
        5: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:18:in `each_pair'
        4: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:19:in `block in validate!'
        3: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:19:in `each_pair'
        2: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:24:in `block (2 levels) in validate!'
        1: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:59:in `validate_format'
Validation::ValidationError (Validation failed, `phone_number` must match Regexp: /\d{10}/)
```

Valid profile:
```
irb(main):012:0> valid_profile = Profile.new(valid_user)
=> #<Profile:0x000055fcb2e62238 @owner=#<User:0x000055fcb3518190 @name="John", @phone_number="1234567890">>

irb(main):013:0> valid_profile.validate!
=> #<Profile:0x000055fcb2e62238 @owner=#<User:0x000055fcb3518190 @name="John", @phone_number="1234567890">>

irb(main):014:0> valid_profile.valid?
=> true
```

Profile with invalid owner:
```
irb(main):015:0> invalid_profile = Profile.new('some_user')
=> #<Profile:0x000055fcb3257cd0 @owner="some_user">

irb(main):016:0> invalid_profile.valid?
=> false

irb(main):017:0> invalid_profile.validate!
Traceback (most recent call last):
       10: from /home/truealisa/.rbenv/versions/2.6.3/bin/irb:23:in `<main>'
        9: from /home/truealisa/.rbenv/versions/2.6.3/bin/irb:23:in `load'
        8: from /home/truealisa/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/irb-1.0.0/exe/irb:11:in `<top (required)>'
        7: from (irb):16
        6: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:18:in `validate!'
        5: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:18:in `each_pair'
        4: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:19:in `block in validate!'
        3: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:19:in `each_pair'
        2: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:24:in `block (2 levels) in validate!'
        1: from /home/truealisa/Dev/test_tasks/gotoinc_test/validation.rb:70:in `validate_type'
Validation::ValidationError (Validation failed, `owner` must be an instance of User)
```
