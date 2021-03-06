require File.dirname(__FILE__) + '/spec_helper'

describe DBAccessor do
  accessor = DBAccessor.new
  let(:customer){ Customer.new({ email: 'The@Fragile.nin', fname: 'JustLikeYouImagined' })}

  before(:each) { accessor.flush_all }
  after(:all)   { accessor.flush_all }

  describe '#set/#get_customer' do
    it 'can set a record in db, then get it' do
      accessor.add_customer(customer)
      db_record = accessor.get_customer(customer.email)
      expect(db_record.fname).to eq customer.fname
    end

    it 'should not allow adding when the email already exists' do
      accessor.add_customer(customer)
      expect{ accessor.add_customer(customer) }.to raise_error NotUniqueError
    end
  end

  describe '#update_customer' do
    it 'should update a customer record' do
      accessor.add_customer(customer)
      customer.lname = 'IWontLetYouFallApart'
      accessor.update_customer(customer)

      expect(accessor.get_customer(customer.email).lname).to eq customer.lname
    end

    it 'should not allow updating a record that does not exist' do
      expect{ accessor.update_customer(customer) }.to raise_error CustomerDoesNotExist
    end
  end

  describe '#expire_customer' do
    it 'can expire a key' do
      accessor.add_customer(customer)
      accessor.expire_customer(customer.email)
      expired_customer = accessor.get_customer(customer.email)
      expect(expired_customer).to be_nil
    end
  end

  describe '#get_customers' do
    it 'returns all entries in the db' do
      accessor.add_customer( Customer.new({ email: 'a@a.nin', fname: '3' }))
      accessor.add_customer( Customer.new({ email: 'b@b.nin', fname: '3' }))
      accessor.add_customer( Customer.new({ email: 'c@c.nin', fname: '3' }))
      customers = accessor.get_customers
      expect(customers.count).to be 3
    end
  end
end
