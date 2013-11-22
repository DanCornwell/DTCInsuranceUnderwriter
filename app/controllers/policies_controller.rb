class PoliciesController < ApplicationController

  def create
    policy = Policy.new(policy_params)
    if policy.valid?
      return policy

    end
  else
    # do something
  end

  private

  def policy_params
    params.require(:policy).permit(:content)
  end

end