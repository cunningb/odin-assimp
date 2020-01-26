package assimp

import "core:os"
import "core:c"
import "core:strings"
import "core:mem"

when os.OS == "darwin" do foreign import lib "system:assimp";
when os.OS == "windows" do foreign import lib "assimp-vc141-mt.lib";


// Helpers
// ------------------------------------------------------------
    // helper proc for slicing a vector back to odin
    slice_vector :: inline proc(c_vector: C_Vector($T)) -> []T {
        return mem.slice_ptr(c_vector.data, int(c_vector.length));
    }

    // helper proc for converting an assimp.String to an odin string
    string_to_string :: inline proc(str: ^String) -> string {
        return strings.string_from_ptr(&str.data[0], int(str.length));
    }
// ----- End Helpers

HINT_MAX_TEXTURE_LEN :: 9;
MAX_NUMBER_OF_COLOR_SETS :: 0x8;
MAX_NUMBER_OF_TEXTURECOORDS :: 0x8;

STRING_MAX_LENGTH :: 1024;

BOOL_FALSE :: 0;
BOOL_TRUE :: 1;

Bool :: c.int;
Real :: c.float; 
Float :: c.float;
Double :: c.double;
Int :: c.int;
UInt :: c.uint;
Char :: c.char;
UChar :: c.uchar;

@(default_calling_convention="c")
foreign lib {

    // cimport.h
    @(link_name="aiImportFile")                         import_file :: proc(file_name: cstring, flags: Post_Process_Steps) -> ^Scene ---;
    @(link_name="aiImportFileEx")                       import_file_ex :: proc(file_name: cstring, flags: UInt, file_io: ^File_IO) -> ^Scene ---;
    @(link_name="aiImportFileExWithProperties")         import_file_ex_with_properties :: proc(file_name: cstring, flags: UInt, file_io: ^File_IO, property_store: ^Property_Store) -> ^Scene ---;
    @(link_name="aiImportFileFromMemory")               import_file_from_memory :: proc(buffer: ^Char, length: UInt, flags: UInt, hint: cstring) -> ^Scene ---;
    @(link_name="aiImportFileFromMemoryWithProperties") import_file_from_memory_with_properties :: proc(buffer: ^Char, length: UInt, flags: UInt, hint: cstring, property_store: ^Property_Store) -> ^Scene ---;
    @(link_name="aiApplyPostProcessing")                apply_post_process :: proc(scene: ^Scene, flags: UInt) -> ^Scene ---;
    @(link_name="aiGetPredefinedLogStream")             get_predefined_log_stream :: proc(streams: Default_Log_Stream, file_name: cstring) -> ^Log_Stream ---;
    @(link_name="aiAttachLogStream")                    attach_log_stream :: proc(stream: ^Log_Stream) ---;
    @(link_name="aiEnableVerboseLogging")               enable_verbose_logging :: proc(d: Bool) ---;
    @(link_name="aiDetachLogStream")                    detach_log_stream :: proc(stream: ^Log_Stream) -> Return ---;
    @(link_name="aiDetachAllLogStreams")                detach_all_log_streams :: proc() ---;
    @(link_name="aiReleaseImport")                      release_import :: proc(scene: ^Scene) ---;
    @(link_name="aiGetErrorString")                     get_error_string :: proc() -> cstring ---;
    @(link_name="aiIsExtensionSupported")               is_extension_supported :: proc(extension: cstring) -> Bool ---;
    @(link_name="aiGetExtensionList")                   get_extension_list :: proc(out: String) ---;
    @(link_name="aiGetMemoryRequirements")              get_memory_requirements :: proc(scene: ^Scene, info: ^Memory_Info) ---;
    @(link_name="aiCreatePropertyStore")                create_property_store :: proc() -> ^Property_Store ---;
    @(link_name="aiReleasePropertyStore")               release_property_store :: proc(store: ^Property_Store) ---;
    @(link_name="aiSetImportPropertyInteger")           set_import_property_integer :: proc(store: ^Property_Store, name: cstring, value: Int) ---;
    @(link_name="aiSetImportPropertyFloat")             set_import_property_float :: proc(store: ^Property_Store, name: cstring, value: Float) ---;
    @(link_name="aiSetImportPropertyString")            set_import_property_string :: proc(store: ^Property_Store, name: cstring, value: ^String) ---;
    @(link_name="aiSetImportPropertyMatrix")            set_import_property_matrix :: proc(store: ^Property_Store, name: cstring, value: ^Matrix_4d) ---;
    @(link_name="aiCreateQuaternionFromMatrix")         create_quaternion_from_matrix :: proc(quat: ^Quaternion, mat: ^Matrix_3d) ---;
    @(link_name="aiDecomposeMatrix")                    decompose_matrix :: proc(mat: ^Matrix_4d, scaling: ^Vector_3d, rotation: ^Quaternion, position: ^Vector_3d) ---;
    @(link_name="aiTransposeMatrix4")                   transpose_matrix_4d :: proc(mat: ^Matrix_4d) ---;
    @(link_name="aiTransposeMatrix3")                   transpose_matrix_3d :: proc(mat: ^Matrix_3d) ---;
    @(link_name="aiTransformVecByMatrix3")              transform_vec_by_matrix_3d :: proc(vec: ^Vector_3d, mat: ^Matrix_3d) ---;
    @(link_name="aiTransformVecByMatrix4")              transform_vec_by_matrix_4d :: proc(vec: ^Vector_3d, mat: ^Matrix_4d) ---;
    @(link_name="aiMultiplyMatrix4")                    multiply_matrix_4d :: proc(dst: ^Matrix_4d, src: ^Matrix_4d) ---;
    @(link_name="aiMultiplyMatrix3")                    multiply_matrix_3d :: proc(dst: ^Matrix_3d, src: ^Matrix_3d) ---;
    @(link_name="aiIdentityMatrix3")                    identity_matrix_3d :: proc(dst: ^Matrix_3d, src: ^Matrix_3d) ---;
    @(link_name="aiIdentityMatrix4")                    identity_matrix_4d :: proc(dst: ^Matrix_3d, src: ^Matrix_3d) ---;
    @(link_name="aiGetImportFormatCount")               get_import_format_count :: proc() -> c.size_t ---;

    // cexport.h
    @(link_name="aiGetExportFormatCount")               get_export_format_count :: proc() -> c.size_t ---;
    @(link_name="aiGetExportFormatDescription")         get_export_format_description :: proc(index: c.size_t) -> ^Export_Format_Desc ---;
    @(link_name="aiReleaseExportFormatDescription")     release_export_format_description :: proc(desc: ^Export_Format_Desc) ---;
    @(link_name="aiCopyScene")                          copy_scene :: proc(scene_in: ^Scene, scene_out: ^^Scene) ---;
    @(link_name="aiFreeScene")                          free_scene :: proc(scene: ^Scene) ---;
    @(link_name="aiExportScene")                        export_scene :: proc(scene: ^Scene, format_id: cstring, file_name: cstring, preprocessing: UInt) -> Return ---;
    @(link_name="aiExportSceneEx")                      export_scene_ex :: proc(scene: ^Scene, format_id: cstring, file_name: cstring, io: ^File_IO, preprocessing: UInt) -> Return ---;
    @(link_name="aiExportSceneToBlob")                  export_scene_to_blob :: proc(scene: ^Scene, format_id: cstring, processing: UInt) -> Export_Blob_Data ---;
    @(link_name="aiReleaseExportBlob")                  release_export_to_blob :: proc(data: ^Export_Blob_Data) ---;

    // material.h
    @(link_name="aiGetMaterialProperty")                get_material_property :: proc(mat: ^Material, key: cstring, texture_type: Texture_Type, index: UInt, material_property_out: ^^Material_Property) -> Return ---;
    @(link_name="aiGetMaterialFloatArray")              get_material_float_array :: proc(mat: ^Material, key: cstring, texture_type: Texture_Type, index: UInt, float_array_out: ^Real, max: ^UInt) -> Return ---;
    @(link_name="aiGetMaterialIntegerArray")            get_material_integer_array :: proc(mat: ^Material, key: cstring, texture_type: Texture_Type, index: UInt, integer_array_out: ^c.int, max: ^UInt) -> Return ---;
    @(link_name="aiGetMaterialColor")                   get_material_color :: proc(mat: ^Material, key: cstring, texture_type: Texture_Type, index: UInt, color_out: Color_4d) -> Return ---;
    @(link_name="aiGetMaterialUVTransform")             get_material_uv_transform :: proc(mat: ^Material, key: cstring, texture_type: Texture_Type, index: UInt, uv_transform_out: ^UV_Transform) -> Return ---;
    @(link_name="aiGetMaterialString")                  get_material_string :: proc(mat: ^Material, key: cstring, texture_type: Texture_Type, index: UInt, string_out: ^String) -> Return ---;
    @(link_name="aiGetMaterialTextureCount")            get_material_texture_count :: proc(mat: ^Material, texture_type: ^Texture_Type) -> UInt ---;
    @(link_name="aiGetMaterialTexture")                 get_material_texture :: proc(mat: ^Material, texture_type: ^Texture_Type, index: UInt, path: ^String, mapping: ^Texture_Mapping, uvindex: ^UInt, blend: ^Real, op: ^Texture_Op, mapmode: ^Texture_Map_Mode, flags: ^UInt) -> Return ---;

    // version.h
    @(link_name="aiGetLegalString")         get_legal_string :: proc() -> cstring ---;
    @(link_name="aiGetVersionMinor")        get_version_minor :: proc() -> UInt ---;
    @(link_name="aiGetVersionMajor")        get_version_major :: proc() -> UInt ---;
    @(link_name="aiGetVersionRevision")     get_branch_revision :: proc() -> UInt ---;
    @(link_name="aiGetBranchName")          get_branch_name :: proc() -> cstring ---;
    @(link_name="aiGetCompileFlags")        get_compile_flags :: proc() -> UInt ---;

    // importerdesc.h
    @(link_name="aiGetImporterDesc")        get_importer_desc :: proc(extension: cstring) -> ^Importer_Desc ---;
}

// Wrapper for C Vectors
C_Vector :: struct(Data: typeid) {
    length: UInt,
    data:   ^Data
}


//#include "cexport.h"
// ------------------------------------------------------------
    Export_Format_Desc :: struct {
        id:             cstring,
        description:    cstring,
        file_extension: cstring
    }

    Export_Blob_Data :: struct {
        size: c.size_t,
        data: rawptr,
        name: String,
        next: ^Export_Blob_Data
    }

// ----- End cexport.h


//#include "cfileio.h"
// ------------------------------------------------------------
    Open_Proc   :: proc"c"(file_io: ^File_IO, str1: cstring, str2: cstring) -> ^File;
    Close_Proc  :: proc"c"(file_io: ^File_IO, file: ^File);

    Write_Proc  :: proc"c"(file: ^File, str: cstring, st1: c.size_t, st2: c.size_t) -> c.size_t;
    Read_Proc   :: proc"c"(file: ^File, str: cstring, st1: c.size_t, st2: c.size_t) -> c.size_t;
    Tell_Proc   :: proc"c"(file: ^File) -> c.size_t;
    Flush_Proc  :: proc"c"(file: ^File);
    Seek_Proc   :: proc"c"(file: ^File, st1: c.size_t, origin: Origin) -> Return;

    User_Data :: cstring;

    File_IO :: struct {
        open_proc:  Open_Proc,
        close_proc: Close_Proc,
        user_data:  User_Data
    }

    File :: struct {
        read_proc:      Read_Proc,
        write_proc:     Write_Proc,
        tell_proc:      Tell_Proc,
        file_size_proc: Tell_Proc,
        seek_proc:      Seek_Proc,
        flush_proc:     Flush_Proc,
        user_data:      User_Data
    }
// ----- End cfileio.h


//#include "cimport.h"
// ------------------------------------------------------------
    Log_Stream_Callback :: proc"c"(message: cstring, user: cstring);

    Log_Stream :: struct {
        callback:   Log_Stream_Callback,
        user:       cstring
    }

    Property_Store :: struct {
        sentinal: Char
    }
// ----- End cimport.h


//#include "importerdesc.h"
// ------------------------------------------------------------
    Importer_Flags :: enum {
        Support_Text_Flavour = 0x1,
        Support_Binary_Flavour = 0x2,
        Support_Compressed_Flavour = 0x4,
        Limited_Support = 0x8,
        Experimental = 0x10
    }

    Importer_Desc :: struct {
        name:       cstring,
        author:     cstring,
        maintainer: cstring,
        comments:   cstring,
        flags:      UInt,

        min_major: UInt,
        min_minor: UInt,

        max_major: UInt,
        max_minor: UInt,

        file_extensions: cstring
    }
// ----- End importerdesc.h




//#include "types.h"
// ------------------------------------------------------------
    Plane :: struct {
        a, b, c, d: Real
    }

    Ray :: struct {
        pos: Vector_3d,
        dir: Vector_3d
    }

    Color_3d :: struct {
        r, g, b: Real
    }

    String :: struct {
        length: UInt,
        data: [STRING_MAX_LENGTH]Char
    }

    Return :: enum {
        Success = 0x00,
        Failure = -0x01,
        Out_Of_Memory = -0x03,
    }

    Origin :: enum {
        Set = 0x00,
        Cur = 0x01,
        END = 0x02
    }

    Default_Log_Stream :: enum {
        File = 0x01,
        Stdout = 0x02,
        Stderr = 0x04,
        Debugger = 0x08,
    }

    // Tracks allocated storage for an import
    Memory_Info :: struct {
        textures: UInt,
        materials: UInt,
        meshes: UInt,
        nodes: UInt,
        animations: UInt,
        cameras: UInt,
        lights: UInt,
        total: UInt
    }
// ----- End types.h


//#include "vector3.h"
Vector_3d :: struct {
    x, y, z: Real
}


//#include "vector2.h"
Vector_2d :: struct {
    x, y: Real
}


//#include "color4.h"
Color_4d :: struct {
    r, g, b, a: Real
}


//#include "matrix3x3.h"
Matrix_3d :: struct {
    a1, a2, a3: Real,
    b1, b2, b3: Real,
    c1, c2, c3: Real

}


//#include "matrix4x4.h"
Matrix_4d :: struct {
    a1, a2, a3, a4: Real,
    b1, b2, b3, b4: Real,
    c1, c2, c3, c4: Real,
    d1, d2, d3, d4: Real
}


//#include "quaternion.h"
Quaternion :: struct {
    w, x, y, z: Real
}


// #include "texture.h"
// ------------------------------------------------------------
    Texel :: struct {
        b, g, r, a: UChar
    }

    Texture :: struct {
        width, height: UInt,
        ach_format_hint: [HINT_MAX_TEXTURE_LEN]Char,
        pc_data: ^Texel,
        file_name: String
    }
// ----- End texture.h


//#include "aabb.h"
AABB :: struct {
    min: Vector_3d,
    max: Vector_3d
}


//#include "mesh.h"
// ------------------------------------------------------------
    Face :: struct {
        indices: C_Vector(UInt)
    }

    Vertex_Weight :: struct {
        vertex_id: Int,
        weight: Float
    }

    Bone :: struct {
        name: String,
        weights: C_Vector(^Vertex_Weight),
        offset_matrix: Matrix_4d
    }

    Primative_Type :: enum {
        Point = 0x1,
        Line = 0x2,
        Triangle = 0x4,
        Polygon = 0x8
    }

    Anim_Mesh :: struct {
        name: String,
        vertices: ^Vector_3d,
        normals: ^Vector_3d,
        tangents: ^Vector_3d,
        bitangents: ^Vector_3d,

        colors: ^[MAX_NUMBER_OF_COLOR_SETS]Color_4d,
        texture_coords: ^[MAX_NUMBER_OF_TEXTURECOORDS]Vector_3d,

        num_verticies: UInt,

        weight: Real
    }

    Morphing_Method :: enum {
        VERTEX_BLEND = 0x1,
        MORPH_NORMALIZED = 0x2,
        MORPH_RELATIVE = 0x3
    }

    Mesh :: struct {
        primative_types: UInt,
        num_vertices: UInt,
        num_faces: UInt,
        vertices: ^Vector_3d,
        normals: ^Vector_3d,
        tangent: ^Vector_3d,
        bitangents: ^Vector_3d,

        colors: [MAX_NUMBER_OF_COLOR_SETS]^Color_4d,
        texture_coords: [MAX_NUMBER_OF_TEXTURECOORDS]^Vector_3d,

        num_uv_components: [MAX_NUMBER_OF_TEXTURECOORDS]UInt,

        faces: ^Face,

        bones: C_Vector(^Bone),

        material_index: UInt,

        name: String,

        anim_meshes: C_Vector(^Anim_Mesh),

        method: UInt,

        aabb: AABB
    }
// ----- End mesh.h


//#include "light.h"
// ------------------------------------------------------------
    Light_Source_Type :: enum {
        Undefined = 0x1,
        Directional = 0x2,
        Point = 0x3,
        Spot = 0x4,
        Ambient = 0x5,
        Area = 0x6
    }

    Light :: struct {
        name: String,
        source_type: Light_Source_Type,

        position: Vector_3d,
        direction: Vector_3d,
        up: Vector_3d,

        attenuation_constant: Float,
        attenuation_linear: Float,
        attenuation_quadratic: Float,

        color_diffuse: Color_3d,
        color_specular: Color_3d,
        color_ambient: Color_3d,

        angle_inner_cone: Float,
        angle_outter_cone: Float,

        size: Vector_2d
    }
// ----- End light.h


//#include "camera.h"
// ------------------------------------------------------------
    Camera :: struct {
        name: String,
        position: Vector_3d,
        up: Vector_3d,
        look_at: Vector_3d,
        horizontal_fov: Float,
        clip_plane_near: Float,
        clip_pane_far: Float,
        aspect: Float
    }
// ----- End camera.h


//#include "material.h"
// ------------------------------------------------------------
    Texture_Op :: enum {
        Multiply = 0x0,
        Add = 0x1,
        Subtract = 0x2,
        Divide = 0x3,
        Smooth_Add = 0x4,
        Signed_Add = 0x5
    }

    Texture_Map_Mode :: enum {
        Wrap = 0x0,
        Clamp = 0x1,
        Decal = 0x3,
        Mirror = 0x2
    }

    Texture_Mapping :: enum {
        UV = 0x0,
        Sphere = 0x1,
        Cylinder = 0x2,
        Box = 0x3,
        Plane = 0x4,
        Other = 0x5
    }

    Texture_Type :: enum {
        None = 0,
        Diffuse = 1,
        Specular = 2,
        Ambient = 3,
        Emissive = 4,
        Height = 5,
        Normals = 6,
        Shininess = 7,
        Opacity = 8,
        Displacement = 9,
        Lightmap = 10,
        Reflection = 11,
        Base_Color = 12,
        Normal_Camera = 13,
        Emission_Color = 14,
        Metalness = 15,
        Diffuse_Roughness = 16,
        Ambient_Occlusion = 17,
        Unknown = 18
    }

    Shading_Mode :: enum {
        Flat = 0x1,
        Gouraud = 0x2,
        Phong = 0x3,
        Blinn = 0x4,
        Toon = 0x5,
        Oren_Nayar = 0x6,
        Minnaert = 0x7,
        Cook_Torrance = 0x8,
        No_Shading = 0x9,
        Fresnel = 0xa
    }

    Texture_Flags :: enum {
        Invert = 0x1,
        Use_Alpha = 0x2,
        Ignore_Alpha = 0x4
    }

    Blend_Mode :: enum {
        Default = 0x0,
        Additive = 0x1
    }

    UV_Transform :: struct {
        translation: Vector_2d,
        scaling: Vector_2d,
        rotation: Real
    }

    Property_Type_Info :: enum {
        Float = 0x1,
        Double = 0x2,
        String = 0x3,
        Integer = 0x4,
        Buffer = 0x5
    }

    Material_Property :: struct {
        key: String,
        semantic: UInt,
        index: UInt,
        data_length: UInt,
        property_type: Property_Type_Info,
        data: ^Char
    }

    Material :: struct {
        properties: ^^Material_Property,
        num_properties: UInt,
        num_allocated: UInt
    }
// ----- End material.h


//#include "anim.h"
// ------------------------------------------------------------
    Vector_Key :: struct {
        time: Float,
        value: Vector_3d
    }

    Quat_Key :: struct {
        time: Float,
        value: Quaternion
    }

    Mesh_Key :: struct {
        time: Float,
        value: UInt
    }

    Mesh_Morph_Key :: struct {
        time: Float,
        values: ^UInt,
        weights: ^Float
    }

    Anim_Behaviour :: enum {
        Default = 0x0,
        Constant = 0x1,
        Linear = 0x2,
        Repeat = 0x3
    }
    
    Node_Anim :: struct {
        name: String,

        position_keys: C_Vector(Vector_Key),
        rotation_keys: C_Vector(Quat_Key),
        scaling_keys: C_Vector(Vector_Key),

        pre_state: Anim_Behaviour,
        post_state: Anim_Behaviour
    }

    Mesh_Anim :: struct {
        name: String,
        keys: C_Vector(Mesh_Key)
    }

    Mesh_Morph_Anim :: struct {
        name: String,
        keys: C_Vector(Mesh_Morph_Key)
    }

    Animation :: struct {
        name: String,
        duration: Double,
        ticks_per_second: Double,

        channels: C_Vector(^Node_Anim),
        mesh_channels: C_Vector(^Mesh_Anim),
        mesh_morph_anim: C_Vector(^Mesh_Morph_Anim)
    }
// ----- End anim.h


//#include "metadata.h"
// ------------------------------------------------------------
    Metadata_Type :: enum {
        Bool = 0,
        Int32 = 1,
        UInt64 = 2,
        Float = 3,
        Double = 4,
        String = 5,
        Vector_3d = 6,
        Meta_Max = 7
    }

    Metadata_Entry :: struct {
        metadata_type: Metadata_Type,
        data: rawptr
    }

    Metadata :: struct {
        num_properties: UInt,
        keys: ^String,
        values: ^Metadata_Entry
    }
// ----- End metadata.h


//#include "postprocess.h"
// ------------------------------------------------------------
    Post_Process_Steps :: enum u32 {
        Calc_Tangent_Space = 0x1,
        Join_Identical_Vertices = 0x2,
        Make_Left_Handed = 0x4,
        Triangulate = 0x8,
        Remove_Component = 0x10,
        Gen_Normals = 0x20,
        Gen_Smooth_Normals = 0x40,
        Split_Large_Meshes = 0x80,
        Pre_Transform_Vertices = 0x100,
        Limit_Bone_Weights = 0x200,
        Validate_Data_Structure = 0x400,
        Improve_Cache_Locality = 0x800,
        Remove_Redundant_Materials = 0x1000,
        Fix_Infacing_Normals = 0x2000,
        Sort_By_PType = 0x8000,
        Find_Degenerates = 0x10000,
        Find_Invalid_Data = 0x20000,
        Gen_UV_Coords = 0x40000,
        Transform_UV_Coords = 0x80000,
        Find_Instances = 0x100000,
        Optimize_Meshes = 0x200000,
        Optimize_Graph = 0x400000,
        Flip_UVs = 0x800000,
        Flip_Winding_Order = 0x1000000,
        Split_By_Bone_Count = 0x2000000,
        Debone = 0x4000000,
        Global_Scale = 0x8000000,
        Embed_Textures = 0x10000000,
        Force_Gen_Normals = 0x20000000,
        Drop_Normals = 0x40000000,
        Gen_Bounding_Boxes = 0x80000000
    }
// ----- End postprocess.h


//#include "scene.h"
// ------------------------------------------------------------
    Node :: struct {
        name: String,
        Transformation: Matrix_4d,
        parent: ^Node,
        children: C_Vector(^Node),
        meshes: C_Vector(UInt),
        metadata: ^Metadata
    }

    Scene_Flags :: enum u32 {
        Incomplete = 0x01,
        Validated = 0x02,
        Validation_Warning = 0x04,
        Non_Verbose_Format = 0x08,
        Terrain = 0x10,
        Allow_Shared = 0x20
    }

    Scene :: struct {
        flags: UInt,
        root_node: ^Node,

        meshes: C_Vector(^Mesh),
        materials: C_Vector(^Material),
        animations: C_Vector(^Animation),
        textures: C_Vector(^Texture),
        lights: C_Vector(^Light),
        cameras: C_Vector(^Camera),

        metadata: ^Metadata
    }
// ----- End scene.h