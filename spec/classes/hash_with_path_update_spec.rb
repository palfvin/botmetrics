require 'spec_helper'

describe HashWithPathUpdate do

  it 'should add a key/val pair for an empty hash' do
    hash = HashWithPathUpdate.new()
    hash.update('foo', 'bar').should == {foo: 'bar'}
  end

  it 'should add a key/val pair to a hash with a different key' do
    hash = HashWithPathUpdate.new()
    hash[:a] = 1
    hash.update('foo', 'bar').should == { a: 1, foo: 'bar'}
  end

  it 'should replace a value for an existing key' do
    hash = HashWithPathUpdate.new()
    hash[:a] = 1
    hash.update('a', 'bar').should == { a: 'bar'}
  end

  it 'should add a key/val pair to a hash with a different key two levels down' do
    hash = HashWithPathUpdate.new()
    hash[:a] = {b: {c: 3}}
    hash.update('a.b.foo', 'bar').should == { a: {b: {c: 3, foo: 'bar'}}}
  end

  it 'should change a value for an existing key two levels down' do
    hash = HashWithPathUpdate.new()
    hash[:a] = {b: {c: 3}}
    hash.update('a.b.c', 'bar').should == { a: {b: {c: 'bar'}}}
  end

  it 'should detect that path does exist two levels down' do
    hash = HashWithPathUpdate.new()
    hash[:a] = {b: {c: 3}}
    hash.path_exists?('a.b.c').should == true
  end

  it 'should detect that path does not exist two levels down' do
    hash = HashWithPathUpdate.new()
    hash[:a] = {b: {c: 3}}
    hash.path_exists?('a.c.b').should == false
  end

  it 'should detect that path does not exist at top level' do
    hash = HashWithPathUpdate.new()
    hash[:a] = {b: {c: 3}}
    hash.path_exists?('b').should == false
  end

  it 'should append a value for an existing key when called with the :append option' do
    hash = HashWithPathUpdate.new()
    hash[:a] = [1]
    hash.update('a', 2, :append).should == { a: [1,2]}
  end


  it 'should add a key/value pair to an empty hash when called with the :append option' do
    hash = HashWithPathUpdate.new()
    hash.update('a', 1, :append).should == { a: 1 }
  end

end
