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
      can :read, :all 
    end
  end
end
