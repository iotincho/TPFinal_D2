<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form reemplaza a Dispose para limpiar la lista de componentes.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Requerido por el Diseñador de Windows Forms
    Private components As System.ComponentModel.IContainer

    'NOTA: el Diseñador de Windows Forms necesita el siguiente procedimiento
    'Se puede modificar usando el Diseñador de Windows Forms.  
    'No lo modifique con el editor de código.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.txtRecibido = New System.Windows.Forms.TextBox()
        Me.lblEstado = New System.Windows.Forms.Label()
        Me.btnBuscarPuertos = New System.Windows.Forms.Button()
        Me.cmbPuertos = New System.Windows.Forms.ComboBox()
        Me.btnConectar = New System.Windows.Forms.Button()
        Me.btnDesconectar = New System.Windows.Forms.Button()
        Me.SPPuerto = New System.IO.Ports.SerialPort(Me.components)
        Me.Label1 = New System.Windows.Forms.Label()
        Me.txtArchivo = New System.Windows.Forms.TextBox()
        Me.lstTiempos = New System.Windows.Forms.ListBox()
        Me.SuspendLayout()
        '
        'txtRecibido
        '
        Me.txtRecibido.Location = New System.Drawing.Point(222, 42)
        Me.txtRecibido.Margin = New System.Windows.Forms.Padding(2)
        Me.txtRecibido.Multiline = True
        Me.txtRecibido.Name = "txtRecibido"
        Me.txtRecibido.Size = New System.Drawing.Size(189, 312)
        Me.txtRecibido.TabIndex = 22
        '
        'lblEstado
        '
        Me.lblEstado.AutoSize = True
        Me.lblEstado.Location = New System.Drawing.Point(438, 65)
        Me.lblEstado.Margin = New System.Windows.Forms.Padding(2, 0, 2, 0)
        Me.lblEstado.Name = "lblEstado"
        Me.lblEstado.Size = New System.Drawing.Size(71, 13)
        Me.lblEstado.TabIndex = 21
        Me.lblEstado.Text = "Desconectdo"
        '
        'btnBuscarPuertos
        '
        Me.btnBuscarPuertos.Location = New System.Drawing.Point(440, 96)
        Me.btnBuscarPuertos.Margin = New System.Windows.Forms.Padding(2)
        Me.btnBuscarPuertos.Name = "btnBuscarPuertos"
        Me.btnBuscarPuertos.Size = New System.Drawing.Size(120, 23)
        Me.btnBuscarPuertos.TabIndex = 20
        Me.btnBuscarPuertos.Text = "Buscar Puertos"
        Me.btnBuscarPuertos.UseVisualStyleBackColor = True
        '
        'cmbPuertos
        '
        Me.cmbPuertos.FormattingEnabled = True
        Me.cmbPuertos.Location = New System.Drawing.Point(440, 42)
        Me.cmbPuertos.Name = "cmbPuertos"
        Me.cmbPuertos.Size = New System.Drawing.Size(121, 21)
        Me.cmbPuertos.TabIndex = 18
        '
        'btnConectar
        '
        Me.btnConectar.Location = New System.Drawing.Point(440, 124)
        Me.btnConectar.Name = "btnConectar"
        Me.btnConectar.Size = New System.Drawing.Size(120, 23)
        Me.btnConectar.TabIndex = 17
        Me.btnConectar.Text = "CONECTAR"
        Me.btnConectar.UseVisualStyleBackColor = True
        '
        'btnDesconectar
        '
        Me.btnDesconectar.Location = New System.Drawing.Point(440, 154)
        Me.btnDesconectar.Name = "btnDesconectar"
        Me.btnDesconectar.Size = New System.Drawing.Size(120, 23)
        Me.btnDesconectar.TabIndex = 16
        Me.btnDesconectar.Text = "DESCONECTAR"
        Me.btnDesconectar.UseVisualStyleBackColor = True
        '
        'SPPuerto
        '
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(19, 398)
        Me.Label1.Margin = New System.Windows.Forms.Padding(2, 0, 2, 0)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(43, 13)
        Me.Label1.TabIndex = 24
        Me.Label1.Text = "Archivo"
        '
        'txtArchivo
        '
        Me.txtArchivo.Location = New System.Drawing.Point(21, 414)
        Me.txtArchivo.Margin = New System.Windows.Forms.Padding(2)
        Me.txtArchivo.Name = "txtArchivo"
        Me.txtArchivo.Size = New System.Drawing.Size(539, 20)
        Me.txtArchivo.TabIndex = 23
        Me.txtArchivo.Text = "C:\Users\Tincho\Desktop\prueva"
        '
        'lstTiempos
        '
        Me.lstTiempos.FormattingEnabled = True
        Me.lstTiempos.Location = New System.Drawing.Point(19, 39)
        Me.lstTiempos.Name = "lstTiempos"
        Me.lstTiempos.Size = New System.Drawing.Size(135, 303)
        Me.lstTiempos.TabIndex = 25
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(599, 460)
        Me.Controls.Add(Me.lstTiempos)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.txtArchivo)
        Me.Controls.Add(Me.txtRecibido)
        Me.Controls.Add(Me.lblEstado)
        Me.Controls.Add(Me.btnBuscarPuertos)
        Me.Controls.Add(Me.cmbPuertos)
        Me.Controls.Add(Me.btnConectar)
        Me.Controls.Add(Me.btnDesconectar)
        Me.Name = "Form1"
        Me.Text = "Form1"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents txtRecibido As System.Windows.Forms.TextBox
    Friend WithEvents lblEstado As System.Windows.Forms.Label
    Friend WithEvents btnBuscarPuertos As System.Windows.Forms.Button
    Friend WithEvents cmbPuertos As System.Windows.Forms.ComboBox
    Friend WithEvents btnConectar As System.Windows.Forms.Button
    Friend WithEvents btnDesconectar As System.Windows.Forms.Button
    Friend WithEvents SPPuerto As System.IO.Ports.SerialPort
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents txtArchivo As System.Windows.Forms.TextBox
    Friend WithEvents lstTiempos As System.Windows.Forms.ListBox

End Class
