# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    case user.role.to_sym
    when :admin
      admin_permissions
    when :hotel_owner
      hotel_owner_permissions(user)
    when :client
      client_permissions(user)
    else
      guest_permissions
    end
  end

  private

  def admin_permissions
    can :manage, :all
  end

  def hotel_owner_permissions(user)
    can :manage, Menu
    can :manage, Hotel, user_id: user.id
    can :read, [Order, OrderItem]
    can :manage, User
  end
  
  def client_permissions(user)
    can :manage, Order
    can :read, [Hotel, Menu, OrderItem]
    can :manage, User
  end

  def guest_permissions
    can :read, :all
  end
end


# class Ability
#   include CanCan::Ability

#   def initialize(user)
#     return unless user.present?

#     case user.role
#     when 'admin'
#       can :manage, :all
#     when 'hotel_owner'
#       can :manage, Menu
#       can :manage, Hotel, user_id: user.id
#       can :read, Order
#       can :read, OrderItem
#       can :manage, User
#     when 'client'
#       can :manage, Order
#       can :read, Hotel
#       can :read, Menu
#       can :read, OrderItem
#       can :manage, User
#     else
#       can :read, :all 
#     end
#   end
# end
