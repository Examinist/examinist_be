class CreateStudentAnswerJob < ApplicationJob
  def perform(args)
    exam = Exam.find_by_id(args[:exam_id])
    return if exam.nil? || exam.starts_at.nil? || exam.starts_at != args[:starts_at]

    create_student_answers(exam)
  end

  private

  def create_student_answers(exam)
    eqs = exam.exam_questions
    exam.students.each do |student|
      student_exam = StudentExam.find_by(student_id: student.id, exam_id: exam.id)
      eqs = eqs.shuffle
      student_answers_to_create = eqs.map do |eq|
        { exam_question_id: eq.id }
      end
      student_exam.student_answers.create!(student_answers_to_create)
    end
  end
end
