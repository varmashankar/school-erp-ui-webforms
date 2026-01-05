-- Patch: ensure dbo.saveStudents defaults @roleTypeId to avoid NULL students.role_id
-- Apply after importing/creating the DB from schoolfullerp.sql

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

ALTER PROCEDURE [dbo].[saveStudents]
    @id INT = NULL,
    @creationTimestamp DATETIME,
    @userId INT = NULL,
    @roleId INT = NULL,
    @roleTypeId INT = NULL,
    @studentCode VARCHAR(50),
    @firstName VARCHAR(50),
    @middleName VARCHAR(50) = NULL,
    @lastName VARCHAR(50),
    @dob VARCHAR(20),
    @gender VARCHAR(20),
    @bloodGroup VARCHAR(10),
    @nationality VARCHAR(50),
    @religion VARCHAR(50) = NULL,
    @nationIdNumber VARCHAR(50),
    @email VARCHAR(100),
    @phone VARCHAR(20),
    @password VARCHAR(50) = NULL,
    @address VARCHAR(MAX),
    @admissionDate VARCHAR(20),
    @classId INT,
    @isTransportRequired BIT,
    @siblingInfo VARCHAR(MAX) = NULL,
    @medicalInfo VARCHAR(MAX) = NULL,
    @admissionNo VARCHAR(50) = NULL,
    @deleted BIT,
    @deletedTimestamp DATETIME = NULL,
    @deletedById INT = NULL,
    @status BIT,
    @outputId INT OUTPUT,
    @message NVARCHAR(MAX) OUTPUT,
    @executionStatus NVARCHAR(MAX) OUTPUT
AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        ---------------------------------------------------------------------
        -- DEFAULTS
        ---------------------------------------------------------------------
        IF (@creationTimestamp IS NULL)
            SET @creationTimestamp = GETDATE();

        IF (@userId IS NULL)
        BEGIN
            SET @userId = 4;
            -- keep existing convention
            IF (@roleTypeId IS NULL) SET @roleTypeId = 4;
        END

        IF (@roleTypeId IS NULL)
            SET @roleTypeId = 4;

        IF (@status IS NULL)
            SET @status = 1;

        IF (@deleted IS NULL)
            SET @deleted = 0;

        ---------------------------------------------------------------------
        -- VALIDATIONS
        ---------------------------------------------------------------------
        IF (@firstName IS NULL OR LTRIM(RTRIM(@firstName)) = '')
        BEGIN
            SET @outputId = 0;
            SET @message = 'First name is required.';
            SET @executionStatus = 'FALSE';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        ---------------------------------------------------------------------
        -- CHECK FOR DUPLICATE STUDENT WHEN INSERTING
        ---------------------------------------------------------------------
        IF (@id IS NULL)
        BEGIN
            IF EXISTS (
                SELECT 1 FROM students
                WHERE (phone = @phone OR email = @email)
                  AND deleted = 0 AND status = 1
            )
            BEGIN
                SET @outputId = (
                    SELECT TOP 1 id FROM students
                    WHERE (phone = @phone OR email = @email)
                      AND deleted = 0 AND status = 1
                );

                SET @message = 'Phone or Email already exists.';
                SET @executionStatus = 'FALSE';
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END

        ---------------------------------------------------------------------
        -- INSERT NEW STUDENT
        ---------------------------------------------------------------------
        IF (@id IS NULL)
        BEGIN
            INSERT INTO students (
                creation_timestamp, created_by_id, role_id, student_code,
                first_name, middle_name, last_name, dob, gender, blood_group,
                nationality, religion, national_id_number, email, phone, password,
                address, admission_date, class_id, is_transport_required,
                sibiling_info, medical_info, admission_no,
                deleted, deleted_timestamp, deleted_by_id, status
            )
            VALUES (
                @creationTimestamp, @userId, @roleTypeId, @studentCode,
                @firstName, @middleName, @lastName, @dob, @gender, @bloodGroup,
                @nationality, @religion, @nationIdNumber, @email, @phone, @password,
                @address, @admissionDate, @classId, @isTransportRequired,
                @siblingInfo, @medicalInfo, @admissionNo,
                @deleted, @deletedTimestamp, @deletedById, @status
            );

            SET @outputId = SCOPE_IDENTITY();

            IF EXISTS (SELECT 1 FROM student_admissions WHERE student_id = @outputId)
            BEGIN
                UPDATE student_admissions
                SET admission_no = @admissionNo,
                    applied_class_id = @classId,
                    admission_date = @admissionDate,
                    status = 'Active'
                WHERE student_id = @outputId;
            END
            ELSE
            BEGIN
                INSERT INTO student_admissions (
                    creation_timestamp,
                    created_by_id,
                    admission_no,
                    student_id,
                    applied_class_id,
                    admission_date,
                    status,
                    deleted,
                    deleted_by_id,
                    deleted_timestamp
                )
                VALUES (
                    @creationTimestamp,
                    @userId,
                    @admissionNo,
                    @outputId,
                    @classId,
                    @admissionDate,
                    'Active',
                    0,
                    NULL,
                    NULL
                );
            END

            SET @message = 'Student saved successfully.';
            SET @executionStatus = 'TRUE';
        END
        ELSE
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM students WHERE id = @id AND deleted = 0 AND status = 1)
            BEGIN
                SET @outputId = 0;
                SET @message = 'Student not found.';
                SET @executionStatus = 'FALSE';
                ROLLBACK TRANSACTION;
                RETURN;
            END

            UPDATE students SET
                first_name = @firstName,
                middle_name = @middleName,
                last_name = @lastName,
                dob = @dob,
                gender = @gender,
                blood_group = @bloodGroup,
                nationality = @nationality,
                religion = @religion,
                national_id_number = @nationIdNumber,
                email = @email,
                phone = @phone,
                address = @address,
                admission_date = @admissionDate,
                class_id = @classId,
                is_transport_required = @isTransportRequired,
                sibiling_info = @siblingInfo,
                medical_info = @medicalInfo,
                admission_no = @admissionNo
            WHERE id = @id;

            SET @outputId = @id;

            IF EXISTS (SELECT 1 FROM student_admissions WHERE student_id = @id)
            BEGIN
                UPDATE student_admissions
                SET admission_no = @admissionNo,
                    applied_class_id = @classId,
                    admission_date = @admissionDate
                WHERE student_id = @id;
            END
            ELSE
            BEGIN
                INSERT INTO student_admissions (
                    creation_timestamp,
                    created_by_id,
                    admission_no,
                    student_id,
                    applied_class_id,
                    admission_date,
                    status,
                    deleted
                )
                VALUES (
                    @creationTimestamp,
                    @userId,
                    @admissionNo,
                    @id,
                    @classId,
                    @admissionDate,
                    'Active',
                    0
                );
            END

            SET @message = 'Student updated successfully.';
            SET @executionStatus = 'TRUE';
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @outputId = 0;
        SET @message = ERROR_MESSAGE();
        SET @executionStatus = 'FALSE';
    END CATCH

END
GO
