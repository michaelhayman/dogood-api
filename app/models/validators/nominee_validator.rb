
module Validators
  class NomineeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      error = "cannot be yourself!"

      if record.done
        if value.present?
          if value.user_id == record.user.id
            record.errors.add(attribute, error)
          end
          if value.email == record.user.email
            record.errors.add(attribute, error)
          end
          if value.phone == record.user.phone
            record.errors.add(attribute, error)
          end
        end
      end
    end
  end
end

