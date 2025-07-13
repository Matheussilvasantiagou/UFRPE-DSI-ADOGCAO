import 'package:flutter/material.dart';
import 'package:adogcao/controllers/edit_user_controller.dart';
import 'package:adogcao/session/UserSession.dart';
import 'package:adogcao/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final EditUserController _controller = EditUserController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _phoneError;
  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  bool isVolunteer = false;
  bool isAdotante = false;
  bool _isLoading = false;
  bool _showPasswordSection = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _nameController.text = UserSession.instance.userName ?? '';
    _phoneController.text = UserSession.instance.userPhone ?? '';
    isVolunteer = UserSession.instance.isVolunteer;
    isAdotante = !isVolunteer;
  }

  void _validateName() {
    setState(() {
      String name = _nameController.text.trim();
      if (name.isEmpty) {
        _nameError = 'Nome é obrigatório';
      } else if (name.length < 2) {
        _nameError = 'Nome deve ter pelo menos 2 caracteres';
      } else {
        _nameError = null;
      }
    });
  }

  void _validateTelefone() {
    setState(() {
      String phone = _phoneController.text.trim();
      if (phone.isEmpty) {
        _phoneError = 'Telefone é obrigatório';
      } else if (phone.length < 10) {
        _phoneError = 'Telefone deve ter pelo menos 10 dígitos';
      } else {
        _phoneError = null;
      }
    });
  }

  void _validateCurrentPassword() {
    setState(() {
      String password = _currentPasswordController.text;
      if (password.isEmpty) {
        _currentPasswordError = 'Senha atual é obrigatória';
      } else {
        _currentPasswordError = null;
      }
    });
  }

  void _validateNewPassword() {
    setState(() {
      String password = _newPasswordController.text;
      if (password.isEmpty) {
        _newPasswordError = 'Nova senha é obrigatória';
      } else if (password.length < 6) {
        _newPasswordError = 'Senha deve ter pelo menos 6 caracteres';
      } else {
        _newPasswordError = null;
      }
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      String password = _confirmPasswordController.text;
      String newPassword = _newPasswordController.text;
      if (password.isEmpty) {
        _confirmPasswordError = 'Confirmação de senha é obrigatória';
      } else if (password != newPassword) {
        _confirmPasswordError = 'Senhas não coincidem';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  void _setVolunteer(bool? value) {
    setState(() {
      isVolunteer = value ?? false;
      isAdotante = !isVolunteer;
      _controller.toggleVolunteer(isVolunteer);
    });
  }

  void _setAdotante(bool? value) {
    setState(() {
      isAdotante = value ?? false;
      isVolunteer = !isAdotante;
      _controller.toggleVolunteer(isVolunteer);
    });
  }

  Future<void> _updatePassword() async {
    _validateCurrentPassword();
    _validateNewPassword();
    _validateConfirmPassword();

    if (_currentPasswordError != null || _newPasswordError != null || _confirmPasswordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        // Reautenticar o usuário antes de alterar a senha
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text,
        );
        
        await user.reauthenticateWithCredential(credential);
        
        // Alterar a senha
        await user.updatePassword(_newPasswordController.text);
        
        // Limpar os campos de senha
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        
        setState(() {
          _showPasswordSection = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Senha alterada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao alterar senha: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    _validateName();
    _validateTelefone();
    
    String name = _nameController.text.trim();
    String phoneNumber = _phoneController.text.trim();

    if (_nameError != null || _phoneError != null) {
      return;
    }

    if (!isVolunteer && !isAdotante) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione um perfil: Voluntário ou Adotante.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _controller.editUser(
        name: name,
        phoneNumber: phoneNumber,
        isVolunteer: isVolunteer,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar perfil: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 13, 32).withAlpha(200),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  const Color.fromARGB(255, 0, 13, 32).withAlpha(200)
                ],
              ),
            ),
          ),
          Column(
            children: [
              // Header
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Editar Perfil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // Para centralizar o título
                    ],
                  ),
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Informações Básicas
                      _buildSectionTitle('Informações Básicas'),
                      const SizedBox(height: 15),
                      
                      // Nome
                      _buildTextField(
                        controller: _nameController,
                        label: 'Nome',
                        hint: 'Digite seu nome completo',
                        error: _nameError,
                        onChanged: (value) => _validateName(),
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 15),
                      
                      // Telefone
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Telefone',
                        hint: 'Digite seu número de telefone',
                        error: _phoneError,
                        onChanged: (value) => _validateTelefone(),
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      
                      // Tipo de Usuário
                      _buildSectionTitle('Tipo de Usuário'),
                      const SizedBox(height: 15),
                      
                      _buildUserTypeSelector(),
                      const SizedBox(height: 30),
                      
                      // Alterar Senha
                      _buildSectionTitle('Segurança'),
                      const SizedBox(height: 15),
                      
                      if (!_showPasswordSection)
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _showPasswordSection = true;
                              });
                            },
                            icon: const Icon(Icons.lock, color: Colors.blue),
                            label: const Text(
                              'Alterar Senha',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      
                      if (_showPasswordSection) ...[
                        _buildPasswordSection(),
                        const SizedBox(height: 20),
                      ],
                      
                      const SizedBox(height: 30),
                      
                      // Botão Salvar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Salvar Alterações',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? error,
    required Function(String) onChanged,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            errorText: error,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade800,
            prefixIcon: Icon(icon, color: Colors.grey.shade400),
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade400,
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade600),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildUserTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: isVolunteer,
                onChanged: _setVolunteer,
                activeColor: Colors.blue,
              ),
              const Expanded(
                child: Text(
                  'Voluntário',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: isAdotante,
                onChanged: _setAdotante,
                activeColor: Colors.blue,
              ),
              const Expanded(
                child: Text(
                  'Adotante',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade600),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Alterar Senha',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _showPasswordSection = false;
                    _currentPasswordController.clear();
                    _newPasswordController.clear();
                    _confirmPasswordController.clear();
                    _currentPasswordError = null;
                    _newPasswordError = null;
                    _confirmPasswordError = null;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          _buildTextField(
            controller: _currentPasswordController,
            label: 'Senha Atual',
            hint: 'Digite sua senha atual',
            error: _currentPasswordError,
            onChanged: (value) => _validateCurrentPassword(),
            icon: Icons.lock,
            obscureText: _obscureCurrentPassword,
            onToggleObscure: () {
              setState(() {
                _obscureCurrentPassword = !_obscureCurrentPassword;
              });
            },
          ),
          const SizedBox(height: 15),
          
          _buildTextField(
            controller: _newPasswordController,
            label: 'Nova Senha',
            hint: 'Digite a nova senha',
            error: _newPasswordError,
            onChanged: (value) => _validateNewPassword(),
            icon: Icons.lock_outline,
            obscureText: _obscureNewPassword,
            onToggleObscure: () {
              setState(() {
                _obscureNewPassword = !_obscureNewPassword;
              });
            },
          ),
          const SizedBox(height: 15),
          
          _buildTextField(
            controller: _confirmPasswordController,
            label: 'Confirmar Nova Senha',
            hint: 'Confirme a nova senha',
            error: _confirmPasswordError,
            onChanged: (value) => _validateConfirmPassword(),
            icon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            onToggleObscure: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _updatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Alterar Senha',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
