require 'spec_helper'

require 'gsaf_log_parser'

describe 'gsaf_log_parser' do
  # Before all because the parser is stateless
  before(:all) do
    @p = GsafLogParser.new
  end

  describe 'parse_row' do
    describe 'case_id' do
      it 'should parse' do
        @p.parse_row({:case_id => 'abc'}).case_id.should == 'abc'
        @p.parse_row({:case_id => '  def '}).case_id.should == 'def'
      end
    end

    describe 'occurred_on' do
      it 'should parse' do
        for_row({:occurred_on => '14-Apr-1906'}).occurred_on.should == Date.parse('1906-04-14')
        for_row({:occurred_on => "June 1827"}).occurred_on.should   == Date.parse('1827-06-01')
      end

      it 'should strip "reported"' do
        for_row({:occurred_on => 'Reported 14-Apr-1906'}).occurred_on.should      == Date.parse('1906-04-14')
        for_row({:occurred_on => 'reported 14-Apr-1906'}).occurred_on.should      == Date.parse('1906-04-14')
        for_row({:occurred_on => "Reported   \t 14-Apr-1906"}).occurred_on.should == Date.parse('1906-04-14')
      end

      it 'should throw out garbage dates' do
        for_row({:occurred_on => "Before 1958"}).occurred_on.should          == nil
        for_row({:occurred_on => "1960s"}).occurred_on.should                == nil
        for_row({:occurred_on => "No date, before 1963"}).occurred_on.should == nil
        for_row({:occurred_on => "1960-1969"}).occurred_on.should            == nil
        for_row({:occurred_on => "Ca. 725 B.C."}).occurred_on.should         == nil
        for_row({:occurred_on => "Late 1600s"}).occurred_on.should           == nil
      end

      it 'should respect nil' do
        for_row({:occurred_on => nil}).occurred_on.should == nil
      end
    end

    describe 'occurred_on_str' do
      it 'should parse literally' do
        for_row({:occurred_on => '14-Apr-1906'}).occurred_on_str.should == '14-Apr-1906'
        for_row({:occurred_on => 'Reported 14-Apr-1906'}).occurred_on_str.should == 'Reported 14-Apr-1906'
      end
    end

    describe 'country' do
      it 'should parse titlecased' do
        for_row({:country => 'SOUTH AFRICA'}).country.should == 'South Africa'
        for_row({:country => 'South Africa'}).country.should == 'South Africa'
      end

      it 'should leave "USA" alone' do
        for_row({:country => 'USA'}).country.should == 'USA'
      end

      it 'should respect nil' do
        for_row({:country => nil}).country.should == nil
      end
    end

    describe 'area' do
      it 'should parse' do
        for_row({:area => 'Texas'}).area.should == 'Texas'
      end
    end

    describe 'location' do
      it 'should parse' do
        for_row({:location => 'Brazos'}).location.should == 'Brazos'
      end
    end

    describe 'activity' do
      it 'should parse' do
        for_row({:activity => 'Swimming'}).activity.should == 'Swimming'
      end
    end

    describe 'name' do
      it 'should parse a real name' do
        for_row({:name => 'John Smith'}).name.should == 'John Smith'
        for_row({:name => 'J.D.'}).name.should == 'J.D.'
      end

      it 'should parse titlecased' do
        for_row({:name => 'jane doe'}).name.should == 'Jane Doe'
      end

      it 'should throw out a gender' do
        for_row({:name => 'male'}).name.should   == nil
        for_row({:name => 'Male'}).name.should   == nil
        for_row({:name => 'Female'}).name.should == nil
        for_row({:name => 'Man'}).name.should    == nil
        for_row({:name => 'woman'}).name.should  == nil
      end

      it 'should throw out a boat' do
        for_row({:name => 'The Seaworthy, a boat'}).name.should == nil
      end

      it 'should throw out an appended note' do
        for_row({:name => 'John Knight (a worthy soul)'}).name.should == 'John Knight'
      end

      it 'should throw out other garbage' do
        for_row({:name => 'Unidentified'}).name.should == nil
      end

      it 'should respect nil' do
        for_row({:name => nil}).name.should == nil
      end
    end

    describe 'sex' do
      it 'should parse downcased' do
        for_row({:sex => 'M'}).sex.should == 'm'
        for_row({:sex => 'f'}).sex.should == 'f'
      end

      it 'should respect nil' do
        for_row({:sex => nil}).sex.should == nil
      end
    end

    describe 'age' do
      it 'should parse' do
        for_row({:age => '17'}).age.should == 17
      end

      it 'should take the first value given a list, i.e. "or"' do
        for_row({:age => '23 or 24'}).age.should == 23
        for_row({:age => '24, 25 or 26'}).age.should == 24
      end

      it 'should respect nil' do
        for_row({:age => nil}).age.should == nil
      end
    end

    describe 'injury' do
      it 'should parse' do
        for_row({:injury => 'Leg bitten off'}).injury.should == 'Leg bitten off'
      end
    end

    describe 'is_fatal' do
      it 'should parse from injury' do
        for_row({:injury => 'Leg bitten off'}).is_fatal.should == false
        for_row({:injury => 'FATAL: Leg bitten off'}).is_fatal.should == true
      end

      it 'should respect nil' do
        for_row({:injury => nil}).is_fatal.should == nil
      end
    end

    describe 'is_provoked' do
      it 'should parse from injury' do
        for_row({:injury => 'Leg bitten off'}).is_provoked.should == false
        for_row({:injury => 'FATAL: Leg bitten off (was provoked)'}).is_provoked.should == true
      end

      it 'should respect nil' do
        for_row({:injury => nil}).is_provoked.should == nil
      end
    end

    describe 'time_of_day' do
      it 'should parse' do
        for_row({:time_of_day => 'Morning'}).time_of_day.should == 'Morning'
      end
    end

    describe 'species' do
      it 'should parse' do
        for_row({:species => 'Great White'}).species.should == 'Great White'
      end
    end

    describe 'source' do
      it 'should parse' do
        for_row({:source => 'New York Times'}).source.should == 'New York Times'
      end
    end
  end

  # case_id must always be included, so include a short helper
  def for_row(row)
    @p.parse_row({:case_id => '123'}.merge(row))
  end
end
