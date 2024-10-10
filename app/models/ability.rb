# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    case user.role
    when 'admin'
      can :manage, :all
    when 'hotel_owner'
      can :manage, Menu
      can :manage, Hotel, user_id: user.id
      can :read, Order
      can :read, OrderItem
      can :manage, User
    when 'client'
      can :manage, Order
      can :read, Hotel
      can :read, Menu
      can :read, OrderItem
      can :manage, User
    else
      # Handle cases where the user role is not recognized
      can :read, :all # or restrict access as needed
    end
  end
end
