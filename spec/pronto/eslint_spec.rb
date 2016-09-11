require 'spec_helper'

module Pronto
  describe ESLintNpm do
    let(:eslint) { ESLintNpm.new(patches) }

    describe '#run' do
      subject(:run) { eslint.run }

      context 'patches are nil' do
        let(:patches) { nil }

        it 'returns an empty array' do
          expect(run).to eql([])
        end
      end

      context 'no patches' do
        let(:patches) { [] }

        it 'returns an empty array' do
          expect(run).to eql([])
        end
      end

      context 'patches with a one and a four warnings' do
        include_context 'test repo'

        let(:patches) { repo.diff('master') }

        it 'returns correct number of errors' do
          expect(run.count).to eql(5)
        end

        it 'has correct first message' do
          expect(run.first.msg).to eql("'foo' is not defined.")
        end
      end

      context 'repo with ignored and not ignored file, each with three warnings' do
        include_context 'eslintignore repo'

        let(:patches) { repo.diff('master') }

        it 'returns correct number of errors' do
          expect(run.count).to eql(3)
        end

        it 'has correct first message' do
          expect(run.first.msg).to eql("'HelloWorld' is defined but never used.")
        end
      end
    end

    describe '.files_to_lint' do
      subject(:files_to_lint) { ESLintNpm.files_to_lint }

      it 'matches .js by default' do
        expect(files_to_lint).to match('my_js.js')
      end

      it 'matches .es6 by default' do
        expect(files_to_lint).to match('my_js.es6')
      end
    end

    describe '.eslint_executable' do
      subject(:eslint_executable) { ESLintNpm.eslint_executable }

      it 'is `eslint` by default' do
        expect(eslint_executable).to eql('eslint')
      end
    end
  end
end
