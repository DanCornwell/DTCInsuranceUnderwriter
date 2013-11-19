class PoliciesController < ApplicationController

  def create
    @policy = current_quote.build_policy(policy_params)
    if @policy.save

    end
  else
    # do something
  end

  private

  def person_params
    params.require(:policy).permit(:content)
  end

end