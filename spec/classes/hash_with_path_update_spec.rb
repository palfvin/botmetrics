require 'spec_helper'

describe HashWithPathUpdate do

  it 'should add a key/val pair for an empty hash' do
    hash = HashWithPathUpdate.new()
    hash.update('foo', 'bar').should == {foo: 'bar'}
  end

  it 'should add a key/val pair to a has with a different key' do
    hash = HashWithPathUpdate.new()
    hash[:a] = 1
    hash.update('foo', 'bar').should == { a: 1, foo: 'bar'}
  end

  it 'should change a value for an existing key' do
    hash = HashWithPathUpdate.new()
    hash[:a] = 1
    hash.update('a', 'bar').should == { a: 'bar'}
  end

  it 'should add a key/val pair to a has with a different key two levels down' do
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

  it 'should deted that path does not exist at top level' do
    hash = HashWithPathUpdate.new()
    hash[:a] = {b: {c: 3}}
    hash.path_exists?('b').should == false
  end

end
