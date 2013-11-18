class PeopleController < ApplicationController

  def create
    @person = current_quote.build_person(person_params)
    if @person.save

    end
  else
    # do something
  end

  private

    def person_params
      params.require(:person).permit(:content)
    end

end